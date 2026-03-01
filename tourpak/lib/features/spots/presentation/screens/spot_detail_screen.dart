import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/cinematic_hero.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../../services/maps_service.dart';
import '../../../weather/presentation/widgets/spot_weather_widget.dart';
import '../../domain/entities/spot.dart';
import '../notifiers/spot_notifier.dart';

// ══════════════════════════════════════════════════════════════
// SPOT DETAIL SCREEN
// ══════════════════════════════════════════════════════════════

class SpotDetailScreen extends ConsumerWidget {
  final String destinationId;
  final String spotId;

  const SpotDetailScreen({
    super.key,
    required this.destinationId,
    required this.spotId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spotAsync = ref.watch(
      spotByIdProvider((destinationId: destinationId, spotId: spotId)),
    );

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: spotAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => ErrorDisplay(
          message: 'Failed to load spot details.',
          onRetry: () => ref.invalidate(
            spotByIdProvider(
                (destinationId: destinationId, spotId: spotId)),
          ),
        ),
        data: (spot) => _SpotDetailContent(
          spot: spot,
          destinationId: destinationId,
        ),
      ),
    );
  }
}

// ── Loading placeholder ──────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DestinationHeroSkeleton(height: 380),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ListItemSkeleton(count: 5),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// MAIN CONTENT
// ══════════════════════════════════════════════════════════════

class _SpotDetailContent extends ConsumerStatefulWidget {
  final Spot spot;
  final String destinationId;

  const _SpotDetailContent({
    required this.spot,
    required this.destinationId,
  });

  @override
  ConsumerState<_SpotDetailContent> createState() =>
      _SpotDetailContentState();
}

class _SpotDetailContentState extends ConsumerState<_SpotDetailContent> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_spots') ?? [];
    if (mounted) {
      setState(() => _isSaved = saved.contains(widget.spot.id));
    }
  }

  Future<void> _toggleSave() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_spots') ?? [];
    if (_isSaved) {
      saved.remove(widget.spot.id);
    } else {
      saved.add(widget.spot.id);
    }
    await prefs.setStringList('saved_spots', saved);
    if (mounted) {
      setState(() => _isSaved = !_isSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    final destinationId = widget.destinationId;
    final screenH = MediaQuery.sizeOf(context).height;
    final heroH = screenH * 0.55;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        // ── Scrollable content ───────────────────────────────
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero section with overlapping title
              SizedBox(
                height: heroH + 40,
                child: Stack(
                  children: [
                    // Hero image
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: heroH,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: 'spot-${spot.id}',
                            child: CinematicHero(
                              imageUrl: spot.heroImageUrl ?? '',
                              height: heroH,
                              enableKenBurns: true,
                            ),
                          ),
                          // Gradient overlay
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 0.4, 1.0],
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  TourPakColors.obsidian,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title + category overlapping bottom
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          Text(
                            spot.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: TourPakColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content below hero
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Info Ribbon ────────────────────────────
                    _InfoRibbon(spot: spot),
                    const SizedBox(height: 20),

                    // ── Weather at this location ────────────────
                    if (spot.hasCoordinates) ...[
                      Text(
                        'Weather at this location',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TourPakColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      WeatherWidget(
                          lat: spot.latitude!, lng: spot.longitude!),
                      const SizedBox(height: 24),
                    ],

                    // ── About ──────────────────────────────────
                    if (spot.description != null &&
                        spot.description!.isNotEmpty)
                      _DescriptionSection(description: spot.description!),
                    if (spot.description != null &&
                        spot.description!.isNotEmpty)
                      const SizedBox(height: 24),

                    // ── Action Buttons ─────────────────────────
                    _ActionButtons(
                      spot: spot,
                      destinationId: destinationId,
                      isSaved: _isSaved,
                      onToggleSave: _toggleSave,
                    ),
                    const SizedBox(height: 24),

                    // ── Nearby Essentials ──────────────────────
                    _NearbySection(spot: spot),
                    const SizedBox(height: 24),

                    // ── Photo Gallery ──────────────────────────
                    if (spot.galleryUrls.isNotEmpty)
                      _PhotoGallery(spot: spot),
                    if (spot.galleryUrls.isNotEmpty)
                      const SizedBox(height: 24),

                    // ── Map & Directions ─────────────────────────
                    if (spot.hasCoordinates) ...[
                      _MapDirectionsSection(spot: spot),
                      const SizedBox(height: 24),
                    ],

                    // ── Nearby Spots ─────────────────────────────
                    _NearbySpotsSection(
                      spot: spot,
                      destinationId: destinationId,
                    ),

                    // Bottom spacer
                    SizedBox(height: 80 + bottomInset),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Top navigation buttons ───────────────────────────
        _TopNavBar(spot: spot),

        // ── Bottom action bar ────────────────────────────────
        _BottomActionBar(spot: spot),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// TOP NAV — Back + Share
// ══════════════════════════════════════════════════════════════

class _TopNavBar extends StatelessWidget {
  final Spot spot;

  const _TopNavBar({required this.spot});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsets.only(
        top: topInset + 8,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlassCard(
            borderRadius: 22,
            padding: const EdgeInsets.all(10),
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: TourPakColors.textPrimary,
              size: 20,
            ),
          ),
          Row(
            children: [
              if (spot.totalPhotos > 1)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GlassCard(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_library_rounded,
                            color: TourPakColors.textPrimary, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${spot.totalPhotos}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: TourPakColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              GlassCard(
                borderRadius: 22,
                padding: const EdgeInsets.all(10),
                onTap: () {
                  Share.share('Check out ${spot.name} on TourPak!');
                },
                child: const Icon(
                  Icons.share_rounded,
                  color: TourPakColors.textPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// INFO RIBBON — 3 stats in a glass row
// ══════════════════════════════════════════════════════════════

class _InfoRibbon extends StatelessWidget {
  final Spot spot;

  const _InfoRibbon({required this.spot});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        icon: Icons.terrain_rounded,
        label: 'Altitude',
        value: spot.altitude != null ? '${spot.altitude!.toInt()}m' : 'N/A',
      ),
      (
        icon: Icons.calendar_month_rounded,
        label: 'Best Time',
        value: spot.bestTime ?? 'Year-round',
      ),
      (
        icon: Icons.confirmation_number_rounded,
        label: 'Entry Fee',
        value: spot.entryFee ?? 'Free',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: TourPakColors.forestGreen.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TourPakColors.goldAction.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
            children: stats.asMap().entries.expand((entry) {
              final s = entry.value;
              final isLast = entry.key == stats.length - 1;
              return [
                Expanded(
                  child: Column(
                    children: [
                      Icon(s.icon,
                          color: TourPakColors.goldAction, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        s.label,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: TourPakColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.value,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TourPakColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
              ];
            }).toList(),
          ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// DESCRIPTION — Expandable
// ══════════════════════════════════════════════════════════════

class _DescriptionSection extends StatefulWidget {
  final String description;

  const _DescriptionSection({required this.description});

  @override
  State<_DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<_DescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: TourPakColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedCrossFade(
          firstChild: Text(
            widget.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: TourPakColors.textSecondary,
              height: 1.6,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: TourPakColors.textSecondary,
              height: 1.6,
            ),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Show less' : 'Read more',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: TourPakColors.goldAction,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ACTION BUTTONS — Navigate, Share, Save, Weather
// ══════════════════════════════════════════════════════════════

class _ActionButtons extends StatelessWidget {
  final Spot spot;
  final String destinationId;
  final bool isSaved;
  final VoidCallback onToggleSave;

  const _ActionButtons({
    required this.spot,
    required this.destinationId,
    required this.isSaved,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        icon: Icons.navigation_rounded,
        label: 'Navigate',
        color: TourPakColors.goldAction,
        onTap: () {
          if (spot.hasCoordinates) {
            MapsService.openDirections(
              spot.latitude!, spot.longitude!, spot.name,
            );
          }
        },
      ),
      (
        icon: Icons.share_rounded,
        label: 'Share',
        color: const Color(0xFF60A5FA),
        onTap: () {
          Share.share('Check out ${spot.name} on TourPak!');
        },
      ),
      (
        icon: isSaved
            ? Icons.bookmark_rounded
            : Icons.bookmark_border_rounded,
        label: isSaved ? 'Saved' : 'Save',
        color: const Color(0xFF34D399),
        onTap: () {
          onToggleSave();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  isSaved
                      ? 'Removed ${spot.name}'
                      : 'Saved ${spot.name}!',
                  style: GoogleFonts.inter(fontSize: 14)),
              backgroundColor: TourPakColors.forestLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
      (
        icon: Icons.wb_sunny_rounded,
        label: 'Weather',
        color: const Color(0xFFF97316),
        onTap: () {
          final query = <String, String>{};
          if (spot.hasCoordinates) {
            query['lat'] = spot.latitude!.toString();
            query['lng'] = spot.longitude!.toString();
          }
          query['name'] = spot.name;
          final qs = query.entries
              .map((e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
              .join('&');
          context.push('/destination/$destinationId/weather?$qs');
        },
      ),
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        final a = entry.value;
        final isLast = entry.key == actions.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 10),
            child: GestureDetector(
              onTap: a.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: TourPakColors.forestGreen
                      .withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(a.icon, color: a.color, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      a.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: TourPakColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// NEARBY SECTION
// ══════════════════════════════════════════════════════════════

class _NearbySection extends StatelessWidget {
  final Spot spot;

  const _NearbySection({required this.spot});

  @override
  Widget build(BuildContext context) {
    final nearby = <(IconData, int, String, Color)>[
      if (spot.nearbyHospitals > 0)
        (Icons.local_hospital_rounded, spot.nearbyHospitals, 'Hospitals',
            TourPakColors.errorRed),
      if (spot.nearbyHotels > 0)
        (Icons.hotel_rounded, spot.nearbyHotels, 'Hotels',
            TourPakColors.goldAction),
      if (spot.nearbyRestaurants > 0)
        (Icons.restaurant_rounded, spot.nearbyRestaurants, 'Restaurants',
            const Color(0xFF34D399)),
      if (spot.nearbyPharmacies > 0)
        (Icons.local_pharmacy_rounded, spot.nearbyPharmacies, 'Pharmacies',
            const Color(0xFF60A5FA)),
    ];

    if (nearby.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Essentials',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: TourPakColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...nearby.map((item) {
          final (icon, count, label, color) = item;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: TourPakColors.forestGreen.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count $label nearby',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: TourPakColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Within walking distance',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: TourPakColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: TourPakColors.textSecondary, size: 16),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// PHOTO GALLERY — Horizontal thumbnails + full-screen viewer
// ══════════════════════════════════════════════════════════════

class _PhotoGallery extends StatelessWidget {
  final Spot spot;

  const _PhotoGallery({required this.spot});

  @override
  Widget build(BuildContext context) {
    final urls = spot.galleryUrls;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: TourPakColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: urls.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == urls.length) {
                return GestureDetector(
                  onTap: () => _openGalleryViewer(context, 0),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.photo_library_rounded,
                            color: TourPakColors.goldAction, size: 24),
                        const SizedBox(height: 6),
                        Text(
                          'View all',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: TourPakColors.goldAction,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () => _openGalleryViewer(context, index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: urls[index],
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                      memCacheHeight: 200,
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: (_, _) =>
                          Container(color: TourPakColors.forestLight),
                      errorWidget: (_, _, _) => Container(
                        color: TourPakColors.forestLight,
                        child: const Icon(Icons.broken_image_rounded,
                            color: TourPakColors.textSecondary, size: 20),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openGalleryViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenGallery(
          imageUrls: spot.galleryUrls,
          initialIndex: initialIndex,
          spotName: spot.name,
        ),
      ),
    );
  }
}

// ── Full-screen gallery viewer ───────────────────────────────

class _FullScreenGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String spotName;

  const _FullScreenGallery({
    required this.imageUrls,
    required this.initialIndex,
    required this.spotName,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    CachedNetworkImageProvider(widget.imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: 'gallery-$index'),
              );
            },
            loadingBuilder: (_, event) => Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  value: event?.expectedTotalBytes != null
                      ? event!.cumulativeBytesLoaded /
                          event.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  color: TourPakColors.goldAction,
                ),
              ),
            ),
            backgroundDecoration:
                const BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: topInset + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassCard(
                  borderRadius: 22,
                  padding: const EdgeInsets.all(10),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close_rounded,
                      color: TourPakColors.textPrimary, size: 20),
                ),
                Text(
                  '${_currentIndex + 1} / ${widget.imageUrls.length}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TourPakColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// BOTTOM ACTION BAR — Get Directions + Save to Trip
// ══════════════════════════════════════════════════════════════

class _BottomActionBar extends StatelessWidget {
  final Spot spot;

  const _BottomActionBar({required this.spot});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
        decoration: BoxDecoration(
          color: TourPakColors.forestGreen.withValues(alpha: 0.95),
          border: const Border(
            top: BorderSide(
              color: TourPakColors.border,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Left: elevation + best time caption
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (spot.altitude != null)
                    Text(
                      '\u{1F3D4} ${spot.altitude!.toInt()}m elevation',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: TourPakColors.textSecondary,
                      ),
                    ),
                  if (spot.bestTime != null)
                    Text(
                      '\u{1F4C5} ${spot.bestTime}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: TourPakColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right: Directions amber button
            GestureDetector(
              onTap: () {
                if (spot.hasCoordinates) {
                  MapsService.openDirections(
                    spot.latitude!, spot.longitude!, spot.name,
                  );
                }
              },
              child: Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8A838),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.navigation_rounded,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Directions',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// MAP & DIRECTIONS SECTION
// ══════════════════════════════════════════════════════════════

class _MapDirectionsSection extends StatelessWidget {
  final Spot spot;

  const _MapDirectionsSection({required this.spot});

  @override
  Widget build(BuildContext context) {
    final center = LatLng(spot.latitude!, spot.longitude!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            const Icon(Icons.location_on_rounded,
                color: TourPakColors.goldAction, size: 20),
            const SizedBox(width: 8),
            Text(
              'Location & Directions',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // FlutterMap
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 230,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 13.5,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.tourpak.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        color: _markerColorForCategory(spot.category),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Coordinates caption
        Text(
          '${spot.latitude!.toStringAsFixed(4)}\u{00B0}N, '
          '${spot.longitude!.toStringAsFixed(4)}\u{00B0}E',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: TourPakColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Directions button (amber CTA)
        GestureDetector(
          onTap: () => MapsService.openDirections(
            spot.latitude!, spot.longitude!, spot.name,
          ),
          child: Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8A838),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.navigation_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Get Directions from My Location',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // "Open in Maps" text button
        Center(
          child: GestureDetector(
            onTap: () => MapsService.openInMaps(
              spot.latitude!, spot.longitude!, spot.name,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Open in Maps',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: TourPakColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Color _markerColorForCategory(String? category) {
    return switch (category?.toLowerCase()) {
      'lake' => const Color(0xFF00BCD4),
      'valley' || 'forest' => const Color(0xFF4CAF50),
      'historical' || 'museum' || 'archaeological' => const Color(0xFFFFC107),
      'waterfall' => const Color(0xFF00ACC1),
      'ski resort' => const Color(0xFF9C27B0),
      _ => const Color(0xFFE53935),
    };
  }
}

// ══════════════════════════════════════════════════════════════
// NEARBY SPOTS — horizontal scroll of 3 closest siblings
// ══════════════════════════════════════════════════════════════

class _NearbySpotsSection extends ConsumerWidget {
  final Spot spot;
  final String destinationId;

  const _NearbySpotsSection({
    required this.spot,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spotsAsync = ref.watch(spotsByDestinationProvider(destinationId));

    return spotsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (spots) {
        // Remove current spot
        var others = spots.where((s) => s.id != spot.id).toList();
        if (others.isEmpty) return const SizedBox.shrink();

        // Sort by distance from current spot if possible
        if (spot.hasCoordinates) {
          others = MapsService.sortByDistance(
            others, spot.latitude!, spot.longitude!,
          );
        }

        final nearby = others.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You might also like',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: nearby.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final s = nearby[index];
                  String? distanceText;
                  if (spot.hasCoordinates && s.hasCoordinates) {
                    final dist = MapsService.distanceBetween(
                      spot.latitude!, spot.longitude!,
                      s.latitude!, s.longitude!,
                    );
                    distanceText = MapsService.formatDistance(dist);
                  }
                  return _NearbySpotCard(
                    spot: s,
                    distanceText: distanceText,
                    onTap: () => context.push(
                      '/destination/$destinationId/spot/${s.id}',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

// ── Small card for nearby spot ──────────────────────────────

class _NearbySpotCard extends StatelessWidget {
  final Spot spot;
  final String? distanceText;
  final VoidCallback onTap;

  const _NearbySpotCard({
    required this.spot,
    this.distanceText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: spot.heroImageUrl ?? '',
                fit: BoxFit.cover,
                memCacheWidth: 300,
                memCacheHeight: 320,
                fadeInDuration: const Duration(milliseconds: 200),
                placeholder: (_, _) =>
                    Container(color: TourPakColors.forestGreen),
                errorWidget: (_, _, _) => Container(
                  color: TourPakColors.forestGreen,
                  child: const Icon(Icons.terrain_rounded,
                      color: TourPakColors.textSecondary, size: 24),
                ),
              ),
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
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      spot.name,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: TourPakColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (distanceText != null)
                      Text(
                        distanceText!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: TourPakColors.textSecondary,
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
