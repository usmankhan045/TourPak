import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/cinematic_hero.dart';

/// Swat Valley hero image for the splash background.
const _kSplashHeroUrl =
    'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=1200';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _titleCtrl;
  late final AnimationController _taglineCtrl;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    // Full-screen immersive — no status bar, no nav bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // ── Title animation: fade-in + slide-up 20px, 800ms ──
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final titleCurve =
        CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut);
    _titleFade = titleCurve;
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(titleCurve);

    // ── Tagline animation: same curve, starts 400ms after title ──
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final taglineCurve =
        CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut);
    _taglineFade = taglineCurve;
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(taglineCurve);

    _runSplashSequence();
  }

  Future<void> _runSplashSequence() async {
    // 1. Start title animation
    _titleCtrl.forward();

    // 2. After 400ms, start tagline
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _taglineCtrl.forward();

    // 3. Wait remaining time for 2.5s total splash duration
    await Future.delayed(const Duration(milliseconds: 2100));
    if (!mounted) return;

    // 4. Restore system UI and navigate
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (!mounted) return;

    // Check if onboarding was completed before
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_complete') ?? false;

    if (!mounted) return;
    context.go(onboardingDone ? '/home' : '/onboarding');
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Full-screen CinematicHero with Ken Burns ──
          CinematicHero(
            imageUrl: _kSplashHeroUrl,
            height: screenHeight,
            enableKenBurns: true,
          ),

          // ── Center branding ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon (mountain + compass placeholder)
                const Icon(
                  Icons.terrain_rounded,
                  color: TourPakColors.goldAction,
                  size: 80,
                ),

                const SizedBox(height: 24),

                // 'TOURPAK' — animated fade-in + slide-up
                AnimatedBuilder(
                  animation: _titleCtrl,
                  builder: (context, child) => Transform.translate(
                    offset: _titleSlide.value,
                    child: Opacity(opacity: _titleFade.value, child: child),
                  ),
                  child: Text(
                    'TOURPAK',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: TourPakColors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 'Pakistan, Simplified.' — same animation, delayed 400ms
                AnimatedBuilder(
                  animation: _taglineCtrl,
                  builder: (context, child) => Transform.translate(
                    offset: _taglineSlide.value,
                    child: Opacity(opacity: _taglineFade.value, child: child),
                  ),
                  child: Text(
                    'Pakistan, Simplified.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: TourPakColors.goldMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom 15%: thin animated gold progress line ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.15,
            child: Center(
              child: SizedBox(
                width: 120,
                height: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: LinearProgressIndicator(
                    backgroundColor: TourPakColors.obsidian.withValues(alpha: 0.5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      TourPakColors.goldAction,
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
}
