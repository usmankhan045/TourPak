import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../destinations/presentation/notifiers/destinations_notifier.dart';

// ── Region data with hero images ────────────────────────────

class _Region {
  final String name;
  final String imageUrl;
  final String subtitle;
  final List<String> provinces;

  const _Region({
    required this.name,
    required this.imageUrl,
    required this.subtitle,
    required this.provinces,
  });
}

const _regions = <_Region>[
  _Region(
    name: 'Gilgit-Baltistan',
    imageUrl:
        'https://images.unsplash.com/photo-1586076000232-5fb3292e5a34?w=800',
    subtitle: 'Hunza, Skardu, Fairy Meadows',
    provinces: ['Gilgit-Baltistan', 'GB'],
  ),
  _Region(
    name: 'KPK',
    imageUrl:
        'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
    subtitle: 'Swat, Chitral, Kumrat',
    provinces: ['KPK', 'Khyber Pakhtunkhwa'],
  ),
  _Region(
    name: 'Punjab',
    imageUrl:
        'https://images.unsplash.com/photo-1567604185000-85b1254ea2f5?w=800',
    subtitle: 'Lahore, Murree, Fort Rohtas',
    provinces: ['Punjab'],
  ),
  _Region(
    name: 'Sindh',
    imageUrl:
        'https://images.unsplash.com/photo-1566396223585-c8fbf4e83398?w=800',
    subtitle: 'Karachi, Mohenjo-daro, Thatta',
    provinces: ['Sindh'],
  ),
  _Region(
    name: 'Balochistan',
    imageUrl:
        'https://images.unsplash.com/photo-1605379399642-870262d3d051?w=800',
    subtitle: 'Quetta, Ziarat, Hingol',
    provinces: ['Balochistan'],
  ),
  _Region(
    name: 'AJK',
    imageUrl:
        'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
    subtitle: 'Neelum Valley, Muzaffarabad',
    provinces: ['AJK', 'Azad Kashmir'],
  ),
];

// ══════════════════════════════════════════════════════════════
// EXPLORE SCREEN
// ══════════════════════════════════════════════════════════════

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.of(context).padding.top;
    final asyncDests = ref.watch(destinationsProvider);

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, topInset + 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore',
                    style: TourPakTextStyles.displayLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover Pakistan by region',
                    style: TourPakTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          // ── Region cards ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final region = _regions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _RegionCard(
                      region: region,
                      destinationCount: asyncDests.whenOrNull(
                            data: (dests) => dests
                                .where((d) => region.provinces.any((p) =>
                                    d.province
                                        ?.toLowerCase()
                                        .contains(p.toLowerCase()) ??
                                    false))
                                .length,
                          ) ??
                          0,
                      onTap: () {
                        final dests = asyncDests.valueOrNull ?? [];
                        final regionDests = dests.where((d) =>
                            region.provinces.any((p) =>
                                d.province
                                    ?.toLowerCase()
                                    .contains(p.toLowerCase()) ??
                                false));
                        if (regionDests.isNotEmpty) {
                          context
                              .push('/destination/${regionDests.first.id}');
                        }
                      },
                    ),
                  );
                },
                childCount: _regions.length,
              ),
            ),
          ),

          // Bottom spacing for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ── Region card ──────────────────────────────────────────────

class _RegionCard extends StatelessWidget {
  final _Region region;
  final int destinationCount;
  final VoidCallback onTap;

  const _RegionCard({
    required this.region,
    required this.destinationCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              CachedNetworkImage(
                imageUrl: region.imageUrl,
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
                    stops: const [0.2, 1.0],
                    colors: [
                      Colors.transparent,
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            region.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: TourPakColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            region.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: TourPakColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (destinationCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: TourPakColors.goldAction,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$destinationCount',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: TourPakColors.obsidian,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Inner border for depth
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
