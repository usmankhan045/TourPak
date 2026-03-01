import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../services/maps_service.dart';
import '../../../spots/domain/entities/spot.dart';
import '../../../spots/presentation/notifiers/spot_notifier.dart';

// ══════════════════════════════════════════════════════════════
// CONSTANTS
// ══════════════════════════════════════════════════════════════

const _pakistanCenter = LatLng(30.3753, 69.3451);
const _defaultZoom = 5.5;

const _categories = [
  'All',
  'Lake',
  'Valley',
  'Waterfall',
  'Historical',
  'Forest',
  'Ski Resort',
];

// ══════════════════════════════════════════════════════════════
// MAP SCREEN — Full-screen map tab with spot markers
// ══════════════════════════════════════════════════════════════

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  Spot? _selectedSpot;
  String _activeFilter = 'All';
  double _currentZoom = _defaultZoom;

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Marker tap ──────────────────────────────────────────────

  void _onMarkerTapped(Spot spot) {
    setState(() => _selectedSpot = spot);
    _mapController.move(
      LatLng(spot.latitude!, spot.longitude!),
      _currentZoom < 10 ? 13.0 : _currentZoom,
    );
  }

  void _clearSelection() {
    setState(() => _selectedSpot = null);
  }

  // ── Filtering ───────────────────────────────────────────────

  List<Spot> _filterSpots(List<Spot> spots) {
    var filtered = spots;

    if (_activeFilter != 'All') {
      filtered = filtered
          .where(
              (s) => s.category?.toLowerCase() == _activeFilter.toLowerCase())
          .toList();
    }

    final q = _searchController.text.toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              (s.category?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return filtered;
  }

  // ── Map controls ────────────────────────────────────────────

  Future<void> _goToMyLocation() async {
    final pos = await MapsService.getCurrentLocation();
    if (pos != null && mounted) {
      _mapController.move(LatLng(pos.latitude, pos.longitude), 12.0);
    }
  }

  void _fitAllSpots(List<Spot> spots) {
    final withCoords = spots.where((s) => s.hasCoordinates).toList();
    if (withCoords.isEmpty) return;

    if (withCoords.length == 1) {
      _mapController.move(
        LatLng(withCoords.first.latitude!, withCoords.first.longitude!),
        13.0,
      );
      return;
    }

    final lats = withCoords.map((s) => s.latitude!).toList();
    final lngs = withCoords.map((s) => s.longitude!).toList();

    final sw = LatLng(
      lats.reduce((a, b) => a < b ? a : b),
      lngs.reduce((a, b) => a < b ? a : b),
    );
    final ne = LatLng(
      lats.reduce((a, b) => a > b ? a : b),
      lngs.reduce((a, b) => a > b ? a : b),
    );

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(sw, ne),
        padding: const EdgeInsets.all(60),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final spotsAsync = ref.watch(allMappableSpotsProvider);
    final screenH = MediaQuery.sizeOf(context).height;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: spotsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: TourPakColors.goldAction),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined,
                  color: TourPakColors.textSecondary, size: 48),
              const SizedBox(height: 12),
              Text(
                'Failed to load map data',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TourPakColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => ref.invalidate(allMappableSpotsProvider),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: TourPakColors.goldAction,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TourPakColors.obsidian,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (allSpots) {
          final spots = _filterSpots(allSpots);

          return Stack(
            children: [
              // ── Full-screen map ──────────────────────────────
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _pakistanCenter,
                  initialZoom: _defaultZoom,
                  minZoom: 4,
                  maxZoom: 18,
                  onPositionChanged: (camera, hasGesture) {
                    if (camera.zoom != _currentZoom) {
                      setState(() => _currentZoom = camera.zoom);
                    }
                  },
                  onTap: (_, _) => _clearSelection(),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.tourpak.app',
                  ),
                  MarkerLayer(
                    markers: spots.where((s) => s.hasCoordinates).map((s) {
                      final isSelected = _selectedSpot?.id == s.id;
                      return Marker(
                        point: LatLng(s.latitude!, s.longitude!),
                        width: isSelected ? 48 : 36,
                        height: isSelected ? 48 : 36,
                        child: GestureDetector(
                          onTap: () => _onMarkerTapped(s),
                          child: _SpotMarker(
                            spot: s,
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // ── Region label (visible at low zoom) ──────────
              if (_currentZoom < 8)
                Positioned(
                  top: topInset + 108,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: TourPakColors.forestGreen
                            .withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              TourPakColors.goldAction.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Swat Valley',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: TourPakColors.goldAction,
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Top search bar + filter chips ────────────────
              Positioned(
                top: topInset + 8,
                left: 16,
                right: 16,
                child: _SearchBarSection(
                  controller: _searchController,
                  activeFilter: _activeFilter,
                  onSearchChanged: () => setState(() {}),
                  onFilterChanged: (f) => setState(() {
                    _activeFilter = f;
                    _selectedSpot = null;
                  }),
                ),
              ),

              // ── Floating controls ────────────────────────────
              Positioned(
                right: 16,
                bottom: _selectedSpot != null ? screenH * 0.30 + 16 : 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FloatingButton(
                      icon: Icons.my_location_rounded,
                      onTap: _goToMyLocation,
                    ),
                    const SizedBox(height: 10),
                    _FloatingButton(
                      icon: Icons.fit_screen_rounded,
                      onTap: () => _fitAllSpots(spots),
                    ),
                  ],
                ),
              ),

              // ── Spot bottom sheet ────────────────────────────
              if (_selectedSpot != null)
                DraggableScrollableSheet(
                  initialChildSize: 0.28,
                  minChildSize: 0.28,
                  maxChildSize: 0.65,
                  snap: true,
                  snapSizes: const [0.28, 0.65],
                  builder: (context, scrollController) {
                    return _SpotSheet(
                      spot: _selectedSpot!,
                      scrollController: scrollController,
                      onClose: _clearSelection,
                      onViewDetails: () {
                        context.push(
                          '/destination/${_selectedSpot!.destinationId}/spot/${_selectedSpot!.id}',
                        );
                      },
                      onNavigate: () {
                        if (_selectedSpot!.hasCoordinates) {
                          MapsService.openDirections(
                            _selectedSpot!.latitude!,
                            _selectedSpot!.longitude!,
                            _selectedSpot!.name,
                          );
                        }
                      },
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SPOT MARKER — Circular icon with category colour
// ══════════════════════════════════════════════════════════════

class _SpotMarker extends StatelessWidget {
  final Spot spot;
  final bool isSelected;

  const _SpotMarker({required this.spot, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = _markerColor(spot.category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? TourPakColors.goldAction : Colors.white,
          width: isSelected ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: isSelected ? 12 : 6,
          ),
        ],
      ),
      child: Icon(
        _iconForCategory(spot.category),
        color: Colors.white,
        size: isSelected ? 20 : 14,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SEARCH BAR + FILTER CHIPS
// ══════════════════════════════════════════════════════════════

class _SearchBarSection extends StatelessWidget {
  final TextEditingController controller;
  final String activeFilter;
  final VoidCallback onSearchChanged;
  final ValueChanged<String> onFilterChanged;

  const _SearchBarSection({
    required this.controller,
    required this.activeFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Glass search bar ─────────────────────────────────
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: TourPakColors.forestGreen.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded,
                  color: TourPakColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (_) => onSearchChanged(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: TourPakColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search spots...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: TourPakColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    controller.clear();
                    onSearchChanged();
                  },
                  child: const Icon(Icons.close_rounded,
                      color: TourPakColors.textSecondary, size: 18),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Category filter chips ────────────────────────────
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isActive = cat == activeFilter;
              return GestureDetector(
                onTap: () => onFilterChanged(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isActive
                        ? TourPakColors.goldAction
                        : TourPakColors.forestGreen.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? TourPakColors.goldAction
                          : Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? TourPakColors.obsidian
                          : TourPakColors.textPrimary,
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
}

// ══════════════════════════════════════════════════════════════
// FLOATING BUTTON — Glass circle
// ══════════════════════════════════════════════════════════════

class _FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Icon(icon, color: TourPakColors.textPrimary, size: 22),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// SPOT SHEET — Draggable bottom sheet content
// ══════════════════════════════════════════════════════════════

class _SpotSheet extends StatelessWidget {
  final Spot spot;
  final ScrollController scrollController;
  final VoidCallback onClose;
  final VoidCallback onViewDetails;
  final VoidCallback onNavigate;

  const _SpotSheet({
    required this.spot,
    required this.scrollController,
    required this.onClose,
    required this.onViewDetails,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: TourPakColors.forestGreen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          left: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          right: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ────────────────────────────────────
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 14),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Header: image + info + close ───────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: spot.heroImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: spot.heroImageUrl!,
                              fit: BoxFit.cover,
                              memCacheWidth: 160,
                              memCacheHeight: 160,
                              fadeInDuration: const Duration(milliseconds: 200),
                              placeholder: (_, _) => Container(
                                  color: TourPakColors.forestLight),
                              errorWidget: (_, _, _) => Container(
                                color: TourPakColors.forestLight,
                                child: const Icon(Icons.terrain_rounded,
                                    color: TourPakColors.textSecondary),
                              ),
                            )
                          : Container(
                              color: TourPakColors.forestLight,
                              child: const Icon(Icons.terrain_rounded,
                                  color: TourPakColors.textSecondary),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spot.name,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: TourPakColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (spot.category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _markerColor(spot.category)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              spot.category!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _markerColor(spot.category),
                              ),
                            ),
                          ),
                        if (spot.altitude != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${spot.altitude!.toInt()}m elevation',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: TourPakColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: TourPakColors.textSecondary, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Description preview ────────────────────────────
            if (spot.description != null && spot.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  spot.description!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: TourPakColors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (spot.description != null && spot.description!.isNotEmpty)
              const SizedBox(height: 16),

            // ── Info chips ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  if (spot.bestTime != null) ...[
                    _InfoChip(
                      icon: Icons.calendar_month_rounded,
                      label: spot.bestTime!,
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (spot.entryFee != null)
                    _InfoChip(
                      icon: Icons.confirmation_number_rounded,
                      label: spot.entryFee!,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Action buttons ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onNavigate,
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8A838),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.navigation_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Directions',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onViewDetails,
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: TourPakColors.textPrimary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'View Details',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: TourPakColors.textPrimary,
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

            // ── Gallery preview (visible when expanded) ────────
            if (spot.galleryUrls.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Photos',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: TourPakColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: spot.galleryUrls.length.clamp(0, 5),
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: CachedNetworkImage(
                          imageUrl: spot.galleryUrls[index],
                          fit: BoxFit.cover,
                          memCacheWidth: 160,
                          memCacheHeight: 160,
                          fadeInDuration: const Duration(milliseconds: 200),
                          placeholder: (_, _) =>
                              Container(color: TourPakColors.forestLight),
                          errorWidget: (_, _, _) =>
                              Container(color: TourPakColors.forestLight),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Small info chip for bottom sheet ─────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: TourPakColors.goldAction, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: TourPakColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// HELPERS — marker colour & icon by category
// ══════════════════════════════════════════════════════════════

Color _markerColor(String? category) {
  return switch (category?.toLowerCase()) {
    'lake' => const Color(0xFF00BCD4),
    'valley' || 'forest' => const Color(0xFF4CAF50),
    'historical' || 'museum' || 'archaeological' => const Color(0xFFFFC107),
    'waterfall' => const Color(0xFF00ACC1),
    'ski resort' => const Color(0xFF9C27B0),
    _ => const Color(0xFFE53935),
  };
}

IconData _iconForCategory(String? category) {
  return switch (category?.toLowerCase()) {
    'lake' => Icons.water_rounded,
    'valley' => Icons.landscape_rounded,
    'forest' => Icons.park_rounded,
    'waterfall' => Icons.water_drop_rounded,
    'historical' || 'museum' || 'archaeological' =>
      Icons.account_balance_rounded,
    'ski resort' => Icons.downhill_skiing_rounded,
    _ => Icons.place_rounded,
  };
}
