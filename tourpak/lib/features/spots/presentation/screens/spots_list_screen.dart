import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/spot.dart';
import '../notifiers/spot_notifier.dart';

// ── Filter categories ────────────────────────────────────────

const _filterCategories = [
  'All',
  'Lake',
  'Mountain',
  'Valley',
  'Heritage',
  'Camping',
  'Forest',
  'Ski Resort',
];

// ══════════════════════════════════════════════════════════════
// SPOTS LIST SCREEN
// ══════════════════════════════════════════════════════════════

class SpotsListScreen extends ConsumerStatefulWidget {
  final String destinationId;

  const SpotsListScreen({super.key, required this.destinationId});

  @override
  ConsumerState<SpotsListScreen> createState() => _SpotsListScreenState();
}

class _SpotsListScreenState extends ConsumerState<SpotsListScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final asyncSpots =
        ref.watch(spotsByDestinationProvider(widget.destinationId));
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 0),
            child: Row(
              children: [
                _GlassBackButton(onTap: () => context.pop()),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tourist Spots',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: TourPakColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Explore destinations nearby',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: TourPakColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Category filter chips ───────────────────────────
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filterCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _filterCategories[index];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? TourPakColors.goldAction
                          : TourPakColors.forestGreen.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? TourPakColors.goldAction
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? TourPakColors.obsidian
                            : TourPakColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Spots list ──────────────────────────────────────
          Expanded(
            child: asyncSpots.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                    color: TourPakColors.goldAction),
              ),
              error: (e, _) => ErrorDisplay(
                message: e.toString(),
                onRetry: () => ref.invalidate(
                    spotsByDestinationProvider(widget.destinationId)),
              ),
              data: (spots) {
                final filtered = _selectedCategory == 'All'
                    ? spots
                    : spots
                        .where((s) =>
                            s.category?.toLowerCase() ==
                            _selectedCategory.toLowerCase())
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.landscape_rounded,
                            size: 48,
                            color:
                                TourPakColors.textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'No spots found',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: TourPakColors.textSecondary,
                          ),
                        ),
                        if (_selectedCategory != 'All')
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Try a different category',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: TourPakColors.textSecondary
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _SpotCard(
                    spot: filtered[index],
                    destinationId: widget.destinationId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SPOT CARD
// ══════════════════════════════════════════════════════════════

class _SpotCard extends StatelessWidget {
  final Spot spot;
  final String destinationId;

  const _SpotCard({required this.spot, required this.destinationId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/destination/$destinationId/spot/${spot.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              CachedNetworkImage(
                imageUrl: spot.heroImageUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(color: TourPakColors.forestGreen),
                errorWidget: (_, _, _) => Container(
                  color: TourPakColors.forestGreen,
                  child: const Icon(Icons.terrain_rounded,
                      color: TourPakColors.textSecondary, size: 48),
                ),
              ),

              // Gradient overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),

              // Content at bottom
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Category chip
                          if (spot.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: TourPakColors.goldAction
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: TourPakColors.goldAction
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                spot.category!.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: TourPakColors.goldAction,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),

                          // Spot name
                          Text(
                            spot.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Altitude subtitle
                          if (spot.altitude != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.terrain_rounded,
                                      size: 14,
                                      color: TourPakColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${spot.altitude!.toInt()}m altitude',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Arrow indicator
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: TourPakColors.goldAction.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              TourPakColors.goldAction.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: TourPakColors.goldAction,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// GLASS BACK BUTTON
// ══════════════════════════════════════════════════════════════

class _GlassBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GlassBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TourPakColors.forestGreen.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: TourPakColors.textPrimary, size: 20),
          ),
        ),
      ),
    );
  }
}
