import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/cinematic_hero.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/entities/destination.dart';
import '../../../spots/domain/entities/spot.dart';
import '../../../spots/presentation/notifiers/spot_notifier.dart';
import '../../../weather/presentation/notifiers/weather_notifier.dart';
import '../../../weather/presentation/widgets/weather_icon.dart';
import '../notifiers/destinations_notifier.dart';

// ── Category grid data ───────────────────────────────────────

class _Cat {
  final IconData icon;
  final String label;
  final Color color;
  const _Cat({required this.icon, required this.label, required this.color});
}

const _categories = [
  _Cat(icon: Icons.landscape_rounded, label: 'Spots', color: TourPakColors.goldAction),
  _Cat(icon: Icons.hotel_rounded, label: 'Hotels', color: TourPakColors.goldAction),
  _Cat(icon: Icons.restaurant_rounded, label: 'Food', color: TourPakColors.goldAction),
  _Cat(icon: Icons.map_rounded, label: 'Guides', color: TourPakColors.goldAction),
  _Cat(icon: Icons.explore_rounded, label: 'Tours', color: TourPakColors.goldAction),
  _Cat(icon: Icons.emergency_rounded, label: 'Emergency', color: TourPakColors.errorRed),
];

// ══════════════════════════════════════════════════════════════
// DESTINATION DETAIL SCREEN
// ══════════════════════════════════════════════════════════════

class DestinationScreen extends ConsumerWidget {
  final String destinationId;

  const DestinationScreen({super.key, required this.destinationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDest = ref.watch(destinationByIdProvider(destinationId));

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: asyncDest.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: TourPakColors.goldAction),
        ),
        error: (e, _) => ErrorDisplay(
          message: e.toString(),
          onRetry: () =>
              ref.invalidate(destinationByIdProvider(destinationId)),
        ),
        data: (dest) => _DestinationBody(dest: dest),
      ),
    );
  }
}

class _DestinationBody extends ConsumerWidget {
  final Destination dest;

  const _DestinationBody({required this.dest});

  String get _altitudeLabel {
    if (dest.latitude == null) return '';
    return '${dest.latitude!.toStringAsFixed(1)}°N';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.of(context).padding.top;
    final screenH = MediaQuery.of(context).size.height;
    final heroH = screenH * 0.45;
    // Ribbon is ~70px tall. We want 32px overlap with hero.
    // Extra space below hero for visible ribbon portion = 70 - 32 = 38
    const ribbonExtra = 38.0;

    final asyncSpots = ref.watch(spotsByDestinationProvider(dest.id));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ══════════════════════════════════════════════════
        // HERO + FLOATING UTILITY RIBBON (combined)
        // ══════════════════════════════════════════════════
        SliverToBoxAdapter(
          child: SizedBox(
            height: heroH + ribbonExtra,
            child: Stack(
              children: [
                // ── Hero image & content (top heroH) ──
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: heroH,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background image
                      CinematicHero(
                        imageUrl: dest.heroImageUrl ?? '',
                        height: heroH,
                        enableKenBurns: true,
                      ),

                      // Gradient overlay
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.5, 1.0],
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              TourPakColors.obsidian,
                            ],
                          ),
                        ),
                      ),

                      // Top nav icons
                      Positioned(
                        top: topInset + 8,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _GlassCircleButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => context.pop(),
                            ),
                            _GlassCircleButton(
                              icon: Icons.search_rounded,
                              onTap: () => context.push('/home/search'),
                            ),
                          ],
                        ),
                      ),

                      // Centered title
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  dest.name.toUpperCase(),
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.black
                                            .withValues(alpha: 0.25),
                                        borderRadius:
                                            BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        [
                                          if (dest.province != null)
                                            dest.province!,
                                          if (_altitudeLabel.isNotEmpty)
                                            _altitudeLabel,
                                        ].join(' | '),
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
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

                // ── Floating utility ribbon (overlaps hero) ──
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: _UtilityRibbon(dest: dest),
                ),
              ],
            ),
          ),
        ),

        // ══════════════════════════════════════════════════
        // CATEGORY GRID (3 × 2)
        // ══════════════════════════════════════════════════
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final cat = _categories[index];
                return _CategoryCard(
                  category: cat,
                  onTap: () => _onCategoryTap(context, cat.label, dest.id),
                );
              },
              childCount: _categories.length,
            ),
          ),
        ),

        // ══════════════════════════════════════════════════
        // MUST VISIT HIGHLIGHTS
        // ══════════════════════════════════════════════════
        SliverToBoxAdapter(
          child: asyncSpots.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: TourPakColors.goldAction,
                  ),
                ),
              ),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (spots) {
              if (spots.isEmpty) return const SizedBox.shrink();
              return _HighlightsSection(
                spots: spots,
                destinationId: dest.id,
              );
            },
          ),
        ),

        // ══════════════════════════════════════════════════
        // DESCRIPTION
        // ══════════════════════════════════════════════════
        if (dest.description != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(
                dest.description!,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.6,
                  color: TourPakColors.textSecondary,
                ),
              ),
            ),
          ),

        // ══════════════════════════════════════════════════
        // BEST MONTHS CHIPS
        // ══════════════════════════════════════════════════
        if (dest.bestMonths.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Icon(Icons.calendar_month_rounded,
                      size: 16, color: TourPakColors.goldMuted),
                  ...dest.bestMonths.map((m) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: TourPakColors.forestGreen
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: TourPakColors.forestLight
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          m[0].toUpperCase() + m.substring(1),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: TourPakColors.textSecondary,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

        // Bottom spacing for nav bar
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  static Color _roadColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'green':
        return TourPakColors.successGreen;
      case 'yellow':
        return TourPakColors.warningAmber;
      case 'red':
        return TourPakColors.errorRed;
      default:
        return TourPakColors.textSecondary;
    }
  }

  static String _roadLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'green':
        return 'Open & Clear';
      case 'yellow':
        return 'Use Caution';
      case 'red':
        return 'Road Closed';
      default:
        return 'Unknown';
    }
  }

  void _onCategoryTap(BuildContext context, String label, String destId) {
    switch (label) {
      case 'Spots':
        context.push('/destination/$destId/spots');
        break;
      case 'Hotels':
      case 'Food':
      case 'Guides':
      case 'Tours':
      case 'Emergency':
        // TODO: Wire up remaining category screens
        break;
    }
  }
}

// ══════════════════════════════════════════════════════════════
// UTILITY RIBBON (weather + road status)
// ══════════════════════════════════════════════════════════════

class _UtilityRibbon extends ConsumerWidget {
  final Destination dest;

  const _UtilityRibbon({required this.dest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWeather = ref.watch(weatherProvider(dest.id));

    // Extract weather data or fallback
    final weatherTemp = asyncWeather.whenOrNull(
      data: (data) => '${data.current.temp.round()}°C',
    );
    final weatherCondition = asyncWeather.whenOrNull(
      data: (data) => data.current.condition.toUpperCase(),
    );
    final weatherIcon = asyncWeather.whenOrNull(
      data: (data) => data.current.iconCode,
    );
    final isLoading = asyncWeather.isLoading;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: TourPakColors.forestGreen.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: TourPakColors.goldAction.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Weather side ──
              if (weatherIcon != null)
                Text(
                  weatherIconEmoji(weatherIcon),
                  style: const TextStyle(fontSize: 24),
                )
              else
                Icon(
                  isLoading ? Icons.cloud_sync_rounded : Icons.wb_sunny_rounded,
                  color: TourPakColors.goldAction,
                  size: 26,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      weatherTemp ?? (isLoading ? '...' : '—'),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TourPakColors.textPrimary,
                      ),
                    ),
                    Text(
                      weatherCondition ?? (isLoading ? 'LOADING' : 'UNAVAILABLE'),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ──
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              const SizedBox(width: 12),

              // ── Road status side ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dest.roadStatusNote?.isNotEmpty == true
                          ? dest.roadStatusNote!
                          : 'Road Status',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: TourPakColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _DestinationBody._roadLabel(dest.roadStatus),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _DestinationBody._roadColor(dest.roadStatus),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Pulsing dot
              _PulsingDot(
                  color: _DestinationBody._roadColor(dest.roadStatus)),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// MUST VISIT HIGHLIGHTS SECTION
// ══════════════════════════════════════════════════════════════

class _HighlightsSection extends StatelessWidget {
  final List<Spot> spots;
  final String destinationId;

  const _HighlightsSection({
    required this.spots,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Must Visit Highlights',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: TourPakColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.push(
                    '/destination/$destinationId/spots'),
                child: Text(
                  'See All',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TourPakColors.goldAction,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: spots.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) =>
                _HighlightCard(
                  spot: spots[index],
                  destinationId: destinationId,
                ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// HIGHLIGHT CARD (horizontal scroll item)
// ══════════════════════════════════════════════════════════════

class _HighlightCard extends StatelessWidget {
  final Spot spot;
  final String destinationId;

  const _HighlightCard({
    required this.spot,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/destination/$destinationId/spot/${spot.id}'),
      child: SizedBox(
        width: 160,
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
                      color: TourPakColors.textSecondary, size: 36),
                ),
              ),

              // Gradient overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.5, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),

              // Content at bottom
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category chip
                    if (spot.category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: TourPakColors.goldAction
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: TourPakColors.goldAction
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          spot.category!.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: TourPakColors.goldAction,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    // Spot name
                    Text(
                      spot.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
// GLASS CIRCLE BUTTON
// ══════════════════════════════════════════════════════════════

class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassCircleButton({required this.icon, required this.onTap});

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
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(icon, color: TourPakColors.textPrimary, size: 20),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// CATEGORY CARD (glass square)
// ══════════════════════════════════════════════════════════════

class _CategoryCard extends StatelessWidget {
  final _Cat category;
  final VoidCallback? onTap;

  const _CategoryCard({required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: TourPakColors.forestGreen.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: TourPakColors.goldAction.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, color: category.color, size: 30),
                const SizedBox(height: 8),
                Text(
                  category.label.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// PULSING DOT
// ══════════════════════════════════════════════════════════════

class _PulsingDot extends StatefulWidget {
  final Color color;

  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ping ring
          AnimatedBuilder(
            animation: _scale,
            builder: (_, _) => Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          // Solid dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
