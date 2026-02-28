import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

// ══════════════════════════════════════════════════════════════
// SAVED SCREEN — empty state with illustration
// ══════════════════════════════════════════════════════════════

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, topInset + 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved',
                    style: TourPakTextStyles.displayLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your favorite destinations',
                    style: TourPakTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          // ── Empty state ──
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon illustration
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TourPakColors.forestGreen.withValues(alpha: 0.5),
                        border: Border.all(
                          color: TourPakColors.forestLight.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.bookmark_outline_rounded,
                        size: 56,
                        color: TourPakColors.goldMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No saved places yet',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: TourPakColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore destinations and tap the bookmark icon to save them here for quick access.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: TourPakColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
