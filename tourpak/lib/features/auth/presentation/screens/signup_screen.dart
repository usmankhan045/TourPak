import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/cinematic_hero.dart';
import '../../../../services/auth_service.dart';

// ══════════════════════════════════════════════════════════════
// SIGN-UP SCREEN
// ══════════════════════════════════════════════════════════════

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── Password strength ─────────────────────────────────────

  double get _passwordStrength {
    final pw = _passwordController.text;
    if (pw.isEmpty) return 0;
    double score = 0;
    if (pw.length >= 6) score += 0.2;
    if (pw.length >= 8) score += 0.1;
    if (pw.length >= 12) score += 0.1;
    if (RegExp(r'[A-Z]').hasMatch(pw)) score += 0.15;
    if (RegExp(r'[a-z]').hasMatch(pw)) score += 0.15;
    if (RegExp(r'[0-9]').hasMatch(pw)) score += 0.15;
    if (RegExp(r'[!@#\$%\^&\*\.\-_]').hasMatch(pw)) score += 0.15;
    return score.clamp(0.0, 1.0);
  }

  String get _strengthLabel {
    final s = _passwordStrength;
    if (s <= 0) return '';
    if (s < 0.35) return 'Weak';
    if (s < 0.65) return 'Fair';
    if (s < 0.85) return 'Good';
    return 'Strong';
  }

  Color get _strengthColor {
    final s = _passwordStrength;
    if (s < 0.35) return TourPakColors.errorRed;
    if (s < 0.65) return const Color(0xFFFFA726);
    if (s < 0.85) return const Color(0xFF66BB6A);
    return TourPakColors.goldAction;
  }

  // ── Sign Up ──────────────────────────────────────────────

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(
          () => _errorMessage = 'Please agree to the Terms & Privacy Policy.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await AuthService.instance.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );

      if (mounted) {
        _showSuccessSheet();
      }
    } on AuthException catch (e) {
      setState(() => _errorMessage = AuthService.friendlyError(e));
    } catch (_) {
      setState(() => _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: TourPakColors.forestGreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: TourPakColors.goldAction.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                color: TourPakColors.goldAction,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Check Your Email',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We sent a confirmation link to\n${_emailController.text.trim()}\n\n'
              'Verify your email, then sign in.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TourPakColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close bottom sheet
                  context.go('/auth/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TourPakColors.goldAction,
                  foregroundColor: TourPakColors.obsidian,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Go to Sign In',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Google Sign-In (skip form, instant) ────────────────────

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await AuthService.instance.signInWithGoogle();
      if (mounted) context.go('/home');
    } on AuthException catch (e) {
      setState(() => _errorMessage = AuthService.friendlyError(e));
    } catch (_) {
      setState(
          () => _errorMessage = 'Google sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Cinematic background ────────────────────────────
          Positioned.fill(
            child: CinematicHero(
              imageUrl:
                  'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=1200',
              height: screenHeight,
              enableKenBurns: true,
            ),
          ),

          // ── Glass panel ─────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.paddingOf(context).top + 20,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: TourPakColors.forestGreen.withValues(alpha: 0.85),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      MediaQuery.paddingOf(context).bottom + 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Back + Title ───────────────────
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: TourPakColors.textPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Create\nAccount',
                            style: TourPakTextStyles.displayLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join TourPak and start exploring Pakistan',
                            style: TourPakTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 24),

                          // ── Full Name ─────────────────────
                          _buildTextField(
                            controller: _nameController,
                            hint: 'Full Name',
                            icon: Icons.person_outline_rounded,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // ── Email ─────────────────────────
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Email address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$')
                                  .hasMatch(v.trim())) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // ── Password ──────────────────────
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: TourPakColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 6) {
                                return 'At least 6 characters';
                              }
                              return null;
                            },
                          ),

                          // ── Strength meter ────────────────
                          if (_passwordController.text.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _passwordStrength,
                                      minHeight: 4,
                                      backgroundColor: TourPakColors
                                          .textSecondary
                                          .withValues(alpha: 0.2),
                                      valueColor: AlwaysStoppedAnimation(
                                          _strengthColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _strengthLabel,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _strengthColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 14),

                          // ── Confirm Password ──────────────
                          _buildTextField(
                            controller: _confirmController,
                            hint: 'Confirm Password',
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscureConfirm,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: TourPakColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (v != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // ── Terms checkbox ────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (v) =>
                                      setState(() => _agreedToTerms = v!),
                                  activeColor: TourPakColors.goldAction,
                                  checkColor: TourPakColors.obsidian,
                                  side: BorderSide(
                                    color: TourPakColors.textSecondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(
                                      () => _agreedToTerms = !_agreedToTerms),
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: TourPakColors.textSecondary,
                                        height: 1.4,
                                      ),
                                      children: [
                                        const TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: TourPakColors.goldAction,
                                          ),
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: TourPakColors.goldAction,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // ── Error message ─────────────────
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: TourPakColors.errorRed,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),

                          // ── Create Account button ─────────
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TourPakColors.goldAction,
                                foregroundColor: TourPakColors.obsidian,
                                disabledBackgroundColor: TourPakColors
                                    .goldAction
                                    .withValues(alpha: 0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: TourPakColors.obsidian,
                                      ),
                                    )
                                  : Text(
                                      'Create Account',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: TourPakColors.obsidian,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Or divider ──────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: TourPakColors.textSecondary
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'or',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: TourPakColors.textSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: TourPakColors.textSecondary
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Google button ───────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed:
                                  _loading ? null : _signInWithGoogle,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TourPakColors.textPrimary,
                                side: BorderSide(
                                  color: TourPakColors.forestLight
                                      .withValues(alpha: 0.6),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.g_mobiledata_rounded,
                                size: 24,
                                color: TourPakColors.textPrimary,
                              ),
                              label: Text(
                                'Continue with Google',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Sign-in link ──────────────────
                          Center(
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: TourPakColors.textSecondary,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Sign In',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: TourPakColors.goldAction,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Reusable text field ────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: TourPakColors.textPrimary,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: TourPakColors.textSecondary.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(icon, color: TourPakColors.textSecondary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: TourPakColors.obsidian.withValues(alpha: 0.5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: TourPakColors.forestLight.withValues(alpha: 0.6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: TourPakColors.goldAction, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: TourPakColors.errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: TourPakColors.errorRed, width: 2),
        ),
      ),
    );
  }
}
