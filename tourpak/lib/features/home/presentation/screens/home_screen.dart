import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/cinematic_hero.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../destinations/domain/entities/destination.dart';
import '../../../destinations/presentation/notifiers/destinations_notifier.dart';

// ── Category data ────────────────────────────────────────────

class _Category {
  final IconData icon;
  final String label;
  const _Category({required this.icon, required this.label});
}

const _categories = [
  _Category(icon: Icons.hiking_rounded, label: 'Trekking'),
  _Category(icon: Icons.restaurant_rounded, label: 'Food'),
  _Category(icon: Icons.landscape_rounded, label: 'Scenic'),
  _Category(icon: Icons.directions_car_rounded, label: 'Transport'),
];

// ══════════════════════════════════════════════════════════════
// HOME SCREEN
// ══════════════════════════════════════════════════════════════

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncDests = ref.watch(destinationsProvider);
    final topInset = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: asyncDests.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: TourPakColors.goldAction),
        ),
        error: (e, _) => ErrorDisplay(
          message: e.toString(),
          onRetry: () => ref.read(destinationsProvider.notifier).refresh(),
        ),
        data: (destinations) {
          // Fixed background — use Swat Valley image
          const bgUrl =
              'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=1200';

          return Stack(
            children: [
              // ── Fixed full-screen cinematic background ──
              Positioned.fill(
                child: CinematicHero(
                  imageUrl: bgUrl,
                  height: screenHeight,
                  enableKenBurns: true,
                ),
              ),

              // ── Gradient overlays ──
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.3, 0.6, 1.0],
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Scrollable content ──
              Positioned.fill(
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.read(destinationsProvider.notifier).refresh(),
                  color: TourPakColors.goldAction,
                  backgroundColor: TourPakColors.forestGreen,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // ── Header ──
                      SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(20, topInset + 12, 20, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'WELCOME TO',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                        letterSpacing: 2.5,
                                      ),
                                    ),
                                    Text(
                                      'TourPak',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: TourPakColors.textPrimary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Notification bell
                              GestureDetector(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 12, sigmaY: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.1),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.notifications_outlined,
                                        color: TourPakColors.textPrimary,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Search bar ──
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          child: GestureDetector(
                            onTap: () => context.push('/home/search'),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.1),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: TourPakColors.forestGreen
                                              .withValues(alpha: 0.4),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: const Icon(
                                          Icons.search_rounded,
                                          color: TourPakColors.textPrimary,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          'Where does your heart want to go?',
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.mic_rounded,
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          size: 22,
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

                      // ── Trending Destinations ──
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Trending Destinations',
                                        style:
                                            GoogleFonts.playfairDisplay(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              TourPakColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        'See All',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              TourPakColors.goldAction,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 380,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: destinations.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 16),
                                  itemBuilder: (context, index) {
                                    final d = destinations[index];
                                    return _TrendingCard(
                                      destination: d,
                                      onTap: () => context.push(
                                          '/destination/${d.id}'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Explore Categories ──
                      SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 28, 20, 0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore Categories',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: TourPakColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: _categories.map((cat) {
                                  return Expanded(
                                    child: _CategoryTile(
                                        category: cat),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom spacing for nav bar
                      const SliverToBoxAdapter(
                          child: SizedBox(height: 100)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// TRENDING CARD (280 × 380, rounded-32)
// ══════════════════════════════════════════════════════════════

class _TrendingCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const _TrendingCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 280,
        height: 380,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              CachedNetworkImage(
                imageUrl: destination.heroImageUrl ?? '',
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
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),

              // Content at bottom
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Road status badge
                    _RoadBadge(status: destination.roadStatus),
                    const SizedBox(height: 10),

                    // Destination name
                    Text(
                      destination.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: TourPakColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        Text(
                          destination.province ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
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
// ROAD STATUS BADGE (glass pill)
// ══════════════════════════════════════════════════════════════

class _RoadBadge extends StatelessWidget {
  final String? status;

  const _RoadBadge({this.status});

  @override
  Widget build(BuildContext context) {
    final s = (status ?? 'green').toLowerCase();
    final Color dotColor;
    final Color bgColor;
    final Color borderColor;
    final String label;

    switch (s) {
      case 'red':
        dotColor = TourPakColors.errorRed;
        bgColor = TourPakColors.errorRed.withValues(alpha: 0.2);
        borderColor = TourPakColors.errorRed.withValues(alpha: 0.3);
        label = 'Road Closed';
        break;
      case 'yellow':
        dotColor = TourPakColors.warningAmber;
        bgColor = TourPakColors.warningAmber.withValues(alpha: 0.2);
        borderColor = TourPakColors.warningAmber.withValues(alpha: 0.3);
        label = 'Caution';
        break;
      default:
        dotColor = TourPakColors.successGreen;
        bgColor = TourPakColors.successGreen.withValues(alpha: 0.2);
        borderColor = TourPakColors.successGreen.withValues(alpha: 0.3);
        label = 'Road Clear';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 0.3,
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
// CATEGORY TILE (glass icon + label)
// ══════════════════════════════════════════════════════════════

class _CategoryTile extends StatelessWidget {
  final _Category category;

  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                category.icon,
                color: TourPakColors.textPrimary,
                size: 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
