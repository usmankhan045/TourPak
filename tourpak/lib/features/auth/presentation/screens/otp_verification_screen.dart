import 'dart:async';
import 'dart:math';
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

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends ConsumerState<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // Resend timer
  Timer? _resendTimer;
  int _resendSeconds = 60;

  // Shake animation
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _shakeController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Auto-verify when all 6 digits are entered
    if (_otp.length == 6) {
      ref.read(authNotifierProvider.notifier).verifyOtp(_otp);
    }
  }

  void _onKeyPressed(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onResend() {
    if (_resendSeconds > 0) return;
    final phone = ref.read(authNotifierProvider).phone;
    ref.read(authNotifierProvider.notifier).sendOtp(phone);
    _startResendTimer();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Mask phone: +92-3XX-XXXXXXX → +92-3**-****567
    final phone = authState.phone;
    final maskedPhone = phone.length >= 6
        ? '${phone.substring(0, 4)}-***-****${phone.substring(phone.length - 3)}'
        : phone;

    // React to state changes
    ref.listen(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        context.goNamed(AppRoutes.home);
      }
      if (next.status == AuthStatus.error) {
        _triggerShake();
        // Clear all fields on error
        for (final c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
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

          // ── Glass panel ────────────────────────────────────
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () {
                          ref.read(authNotifierProvider.notifier).reset();
                          context.pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: TourPakColors.textPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Header
                      Text(
                        'Verify your\nnumber',
                        style: TourPakTextStyles.displayLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the 6-digit code sent to $maskedPhone',
                        style: TourPakTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 28),

                      // OTP digit boxes
                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          final shake = sin(_shakeAnimation.value * pi * 4) * 8;
                          return Transform.translate(
                            offset: Offset(shake, 0),
                            child: child,
                          );
                        },
                        child: _buildOtpBoxes(authState),
                      ),

                      // Error message
                      if (authState.status == AuthStatus.error &&
                          authState.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            authState.errorMessage!,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: TourPakColors.errorRed,
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Verifying indicator
                      if (authState.status == AuthStatus.verifying)
                        const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: TourPakColors.goldAction,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Resend
                      Center(
                        child: _resendSeconds > 0
                            ? Text(
                                'Resend code in ${_resendSeconds}s',
                                style: TourPakTextStyles.bodyMedium,
                              )
                            : GestureDetector(
                                onTap: _onResend,
                                child: Text(
                                  'Resend Code',
                                  style: TourPakTextStyles.labelGold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBoxes(AuthState authState) {
    final isError = authState.status == AuthStatus.error;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        final hasValue = _controllers[i].text.isNotEmpty;

        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyPressed(i, event),
            child: TextFormField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: TourPakColors.obsidian.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isError
                        ? TourPakColors.errorRed
                        : hasValue
                            ? TourPakColors.goldAction
                            : TourPakColors.forestLight.withValues(alpha: 0.6),
                    width: hasValue ? 2 : 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isError
                        ? TourPakColors.errorRed
                        : TourPakColors.goldAction,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => _onDigitChanged(i, value),
            ),
          ),
        );
      }),
    );
  }
}
