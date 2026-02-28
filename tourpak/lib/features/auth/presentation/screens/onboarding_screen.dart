import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/cinematic_hero.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/road_status_badge.dart';

// ── Page data ────────────────────────────────────────────────

class _PageData {
  final String imageUrl;
  final String headline;
  final String body;
  final Widget? extra;

  const _PageData({
    required this.imageUrl,
    required this.headline,
    required this.body,
    this.extra,
  });
}

const _kOnboardingCompleteKey = 'onboarding_complete';

final _pages = <_PageData>[
  const _PageData(
    imageUrl:
        'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=1200',
    headline: 'Every destination.\nOne app.',
    body: 'Hotels, restaurants, guides — consolidated.',
  ),
  const _PageData(
    imageUrl:
        'https://images.unsplash.com/photo-1567604185000-85b1254ea2f5?w=1200',
    headline: 'Your safety,\nour priority.',
    body:
        'Live road conditions, hospitals, emergency contacts — one tap away.',
    extra: RoadStatusBadge(
      status: 'green',
      note: 'Karakoram Highway — Road Open',
    ),
  ),
  const _PageData(
    imageUrl:
        'https://images.unsplash.com/photo-1586076000232-5fb3292e5a34?w=1200',
    headline: 'Pakistan\nawaits.',
    body: 'Start your journey. Swat, Naran, Hunza and beyond.',
  ),
];

// ── Screen ───────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingCompleteKey, true);
    if (!mounted) return;
    context.go('/home');
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── PageView: full-screen CinematicHero per page ──
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, index) => CinematicHero(
              imageUrl: _pages[index].imageUrl,
              height: screenHeight,
              enableKenBurns: true,
            ),
          ),

          // ── Stronger gradient overlay (covers bottom 55%) ──
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.40, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    TourPakColors.obsidian,
                  ],
                ),
              ),
            ),
          ),

          // ── Content + dots + buttons (bottom half) ──
          Positioned(
            left: 24,
            right: 24,
            top: screenHeight * 0.50,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Animated page content ──
                Flexible(
                  child: _AnimatedPageContent(
                    key: ValueKey(_currentPage),
                    page: _pages[_currentPage],
                  ),
                ),

                // ── Page dots ──
                Row(
                  children: List.generate(
                    _pages.length,
                    (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: isActive ? 8 : 5,
                        height: isActive ? 8 : 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? TourPakColors.goldAction
                              : Colors.white,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ── Navigation buttons ──
                if (_currentPage < 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip (ghost)
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: TourPakColors.textSecondary,
                          ),
                        ),
                      ),

                      // Next → (GlassCard)
                      GlassCard(
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        onTap: _nextPage,
                        child: Text(
                          'Next →',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: TourPakColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // Page 3: full-width gold Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _completeOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TourPakColors.goldAction,
                        foregroundColor: TourPakColors.obsidian,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Get Started →',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: TourPakColors.obsidian,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: bottomPadding + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated content per page ────────────────────────────────

class _AnimatedPageContent extends StatelessWidget {
  final _PageData page;

  const _AnimatedPageContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            page.headline,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: TourPakColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            page.body,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: TourPakColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (page.extra != null) ...[
            const SizedBox(height: 16),
            page.extra!,
          ],
          const SizedBox(height: 24),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideY(begin: 0.15, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}
