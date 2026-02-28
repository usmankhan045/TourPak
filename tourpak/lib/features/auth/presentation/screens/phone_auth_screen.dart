import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourpak/core/router/app_router.dart';
import 'package:tourpak/core/theme/colors.dart';
import 'package:tourpak/core/theme/text_styles.dart';
import 'package:tourpak/core/widgets/cinematic_hero.dart';
import 'package:tourpak/features/auth/presentation/notifiers/auth_notifier.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (!_formKey.currentState!.validate()) return;
    final phone = '+92${_phoneController.text.trim()}';
    ref.read(authNotifierProvider.notifier).sendOtp(phone);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Navigate to OTP screen when OTP is sent
    ref.listen(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.otpSent) {
        context.pushNamed(AppRoutes.otpVerification);
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Cinematic background ───────────────────────────
          Positioned.fill(
            child: CinematicHero(
              imageUrl:
                  'https://images.unsplash.com/photo-1566396223585-c8fbf4e83398?w=1200',
              height: screenHeight,
              enableKenBurns: true,
            ),
          ),

          // ── Glass panel (sliding up from bottom) ──────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    32,
                    24,
                    MediaQuery.paddingOf(context).bottom + 24,
                  ),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Welcome to\nTourPak',
                          style: TourPakTextStyles.displayLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your phone number to get started',
                          style: TourPakTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 28),

                        // Phone input
                        _buildPhoneField(),
                        const SizedBox(height: 8),

                        // Error message
                        if (authState.status == AuthStatus.error &&
                            authState.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              authState.errorMessage!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: TourPakColors.errorRed,
                              ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Send OTP button
                        _buildSendButton(authState),
                      ],
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

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: TourPakColors.textPrimary,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Phone number is required';
        }
        if (value.trim().length < 10) {
          return 'Enter a valid 10-digit number';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pakistan flag
              Text('🇵🇰', style: GoogleFonts.inter(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                '+92',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: TourPakColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 24,
                color: TourPakColors.textSecondary.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
        hintText: '3XX XXXXXXX',
        hintStyle: GoogleFonts.inter(
          fontSize: 18,
          color: TourPakColors.textSecondary.withValues(alpha: 0.5),
        ),
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
      ),
    );
  }

  Widget _buildSendButton(AuthState authState) {
    final isLoading = authState.status == AuthStatus.sendingOtp;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onSendOtp,
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
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: TourPakColors.obsidian,
                ),
              )
            : Text(
                'Send OTP →',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.obsidian,
                ),
              ),
      ),
    );
  }
}
