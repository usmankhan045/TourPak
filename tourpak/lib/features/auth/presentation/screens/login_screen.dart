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
import '../providers/auth_state_provider.dart';

// ══════════════════════════════════════════════════════════════
// LOGIN SCREEN — Email + Google + Guest
// ══════════════════════════════════════════════════════════════

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Email Sign-In ─────────────────────────────────────────

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await AuthService.instance.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/home');
    } on AuthException catch (e) {
      setState(() => _errorMessage = AuthService.friendlyError(e));
    } catch (_) {
      setState(() => _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Google Sign-In ────────────────────────────────────────

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
      setState(() => _errorMessage = 'Google sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Forgot Password ──────────────────────────────────────

  void _showForgotPasswordDialog() {
    final resetController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => _ForgotPasswordDialog(controller: resetController),
    );
  }

  // ── Guest Mode ────────────────────────────────────────────

  void _browseAsGuest() {
    ref.read(guestModeProvider.notifier).state = true;
    context.go('/home');
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
                  'https://images.unsplash.com/photo-1566396223585-c8fbf4e83398?w=1200',
              height: screenHeight,
              enableKenBurns: true,
            ),
          ),

          // ── Glass panel (bottom sheet) ──────────────────────
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
                      32,
                      24,
                      MediaQuery.paddingOf(context).bottom + 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Title ──────────────────────────
                          Text(
                            'Welcome\nBack',
                            style: TourPakTextStyles.displayLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue your journey',
                            style: TourPakTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 24),

                          // ── Email field ───────────────────
                          _buildEmailField(),
                          const SizedBox(height: 14),

                          // ── Password field ────────────────
                          _buildPasswordField(),
                          const SizedBox(height: 8),

                          // ── Forgot password ───────────────
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _showForgotPasswordDialog,
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: TourPakColors.goldAction,
                                ),
                              ),
                            ),
                          ),

                          // ── Error ─────────────────────────
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

                          // ── Sign-In button ────────────────
                          _buildSignInButton(),
                          const SizedBox(height: 16),

                          // ── Or divider ────────────────────
                          _buildOrDivider(),
                          const SizedBox(height: 16),

                          // ── Google button ─────────────────
                          _buildGoogleButton(),
                          const SizedBox(height: 20),

                          // ── Sign-up link ──────────────────
                          Center(
                            child: GestureDetector(
                              onTap: () => context.push('/auth/signup'),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: TourPakColors.textSecondary,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text: "Don't have an account? "),
                                    TextSpan(
                                      text: 'Sign Up',
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
                          const SizedBox(height: 12),

                          // ── Browse as Guest ───────────────
                          Center(
                            child: TextButton(
                              onPressed: _browseAsGuest,
                              child: Text(
                                'Browse as Guest',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: TourPakColors.textSecondary,
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

  // ── Widgets ────────────────────────────────────────────────

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: TourPakColors.textPrimary,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Email is required';
        if (!RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$').hasMatch(v.trim())) {
          return 'Enter a valid email';
        }
        return null;
      },
      decoration: _inputDecoration(
        hint: 'Email address',
        prefixIcon: Icons.email_outlined,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: TourPakColors.textPrimary,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Password is required';
        return null;
      },
      decoration: _inputDecoration(
        hint: 'Password',
        prefixIcon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: TourPakColors.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _loading ? null : _signInWithEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: TourPakColors.goldAction,
          foregroundColor: TourPakColors.obsidian,
          disabledBackgroundColor:
              TourPakColors.goldAction.withValues(alpha: 0.6),
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
                'Sign In',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.obsidian,
                ),
              ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: TourPakColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
            color: TourPakColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _loading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          foregroundColor: TourPakColors.textPrimary,
          side: BorderSide(
            color: TourPakColors.forestLight.withValues(alpha: 0.6),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Image.network(
          'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
          width: 20,
          height: 20,
          errorBuilder: (_, _, _) => const Icon(
            Icons.g_mobiledata_rounded,
            size: 24,
            color: TourPakColors.textPrimary,
          ),
        ),
        label: Text(
          'Continue with Google',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        color: TourPakColors.textSecondary.withValues(alpha: 0.5),
      ),
      prefixIcon: Icon(prefixIcon, color: TourPakColors.textSecondary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: TourPakColors.obsidian.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
    );
  }
}

// ══════════════════════════════════════════════════════════════
// FORGOT PASSWORD DIALOG
// ══════════════════════════════════════════════════════════════

class _ForgotPasswordDialog extends StatefulWidget {
  final TextEditingController controller;
  const _ForgotPasswordDialog({required this.controller});

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  bool _sending = false;
  String? _message;
  bool _success = false;

  Future<void> _sendReset() async {
    final email = widget.controller.text.trim();
    if (email.isEmpty) {
      setState(() => _message = 'Please enter your email.');
      return;
    }
    setState(() {
      _sending = true;
      _message = null;
    });
    try {
      await AuthService.instance.sendPasswordReset(email);
      setState(() {
        _success = true;
        _message = 'Password reset email sent! Check your inbox.';
      });
    } on AuthException catch (e) {
      setState(() => _message = AuthService.friendlyError(e));
    } catch (_) {
      setState(() => _message = 'Failed to send reset email.');
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TourPakColors.forestGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Reset Password',
        style: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: TourPakColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter the email associated with your account and '
            "we'll send you a password reset link.",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: TourPakColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: TourPakColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Email address',
              hintStyle: GoogleFonts.inter(
                fontSize: 15,
                color: TourPakColors.textSecondary.withValues(alpha: 0.5),
              ),
              filled: true,
              fillColor: TourPakColors.obsidian.withValues(alpha: 0.5),
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
                borderSide: const BorderSide(
                    color: TourPakColors.goldAction, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(
              _message!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color:
                    _success ? TourPakColors.forestLight : TourPakColors.errorRed,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            _success ? 'Done' : 'Cancel',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TourPakColors.textSecondary,
            ),
          ),
        ),
        if (!_success)
          TextButton(
            onPressed: _sending ? null : _sendReset,
            child: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TourPakColors.goldAction,
                    ),
                  )
                : Text(
                    'Send Link',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TourPakColors.goldAction,
                    ),
                  ),
          ),
      ],
    );
  }
}
