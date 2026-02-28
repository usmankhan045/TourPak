import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tourpak/core/theme/colors.dart';

// ── Helper ──────────────────────────────────────────────────

/// Wraps a skeleton and the real content, showing the skeleton while
/// [isLoading] is true and the [child] once data is ready.
class SkeletonLoader extends StatelessWidget {
  final Widget skeleton;
  final bool isLoading;
  final Widget child;

  const SkeletonLoader({
    super.key,
    required this.skeleton,
    required this.isLoading,
    required this.child,
  });

  /// Shorthand constructor that mirrors a static-method feel.
  static Widget wrap(Widget skeleton, bool isLoading, Widget child) {
    return SkeletonLoader(skeleton: skeleton, isLoading: isLoading, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? skeleton : child;
  }
}

// ── Shared bone builder ─────────────────────────────────────

Widget _bone({
  double width = double.infinity,
  double height = 14,
  double radius = 8,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: TourPakColors.forestGreen,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

Widget _shimmerWrap({required Widget child}) {
  return Shimmer.fromColors(
    baseColor: TourPakColors.forestGreen,
    highlightColor: TourPakColors.forestLight,
    child: child,
  );
}

// ── 1. DestinationCardSkeleton ──────────────────────────────

/// Matches the size of a full-width destination card:
/// rounded image area on top, two text lines below.
class DestinationCardSkeleton extends StatelessWidget {
  const DestinationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            color: TourPakColors.obsidian,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area — fills available space
              Expanded(child: _bone(radius: 0)),
              const SizedBox(height: 10),
              // Title line
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _bone(width: 120, height: 14),
              ),
              const SizedBox(height: 6),
              // Subtitle line
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _bone(width: 80, height: 10),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 2. SpotCardSkeleton ─────────────────────────────────────

/// Small horizontal card: square photo on left, text lines on right.
class SpotCardSkeleton extends StatelessWidget {
  const SpotCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TourPakColors.obsidian,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            // Square photo
            _bone(width: 72, height: 72, radius: 16),
            const SizedBox(width: 12),
            // Text lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bone(width: 140, height: 14),
                  const SizedBox(height: 8),
                  _bone(width: 100, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 3. DestinationHeroSkeleton ──────────────────────────────

/// Full-width tall rectangle matching the CinematicHero image area.
class DestinationHeroSkeleton extends StatelessWidget {
  final double height;

  const DestinationHeroSkeleton({super.key, this.height = 400});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      child: _bone(height: height, radius: 0),
    );
  }
}

// ── 4. ListItemSkeleton ─────────────────────────────────────

/// Repeating list-item pattern: avatar circle + two text lines.
class ListItemSkeleton extends StatelessWidget {
  final int count;

  const ListItemSkeleton({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      child: Column(
        children: List.generate(count, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Avatar circle
                _bone(width: 44, height: 44, radius: 22),
                const SizedBox(width: 12),
                // Two text lines
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bone(width: 160, height: 14),
                      const SizedBox(height: 6),
                      _bone(width: 100, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
