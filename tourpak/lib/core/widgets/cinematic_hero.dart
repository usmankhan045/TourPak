import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tourpak/core/theme/colors.dart';

/// Cinematic hero image widget for destination cards.
///
/// Combines a Ken Burns slow-zoom animation, an optional parallax shift,
/// cached image loading with dark shimmer, and a bottom gradient that
/// guarantees text readability over any image.
class CinematicHero extends StatefulWidget {
  final String imageUrl;
  final double height;
  final Widget? overlay;
  final bool enableKenBurns;
  final bool enableParallax;
  final ScrollController? scrollController;

  const CinematicHero({
    super.key,
    required this.imageUrl,
    this.height = 400,
    this.overlay,
    this.enableKenBurns = true,
    this.enableParallax = false,
    this.scrollController,
  });

  @override
  State<CinematicHero> createState() => _CinematicHeroState();
}

class _CinematicHeroState extends State<CinematicHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _kenBurnsController;
  late final Animation<double> _scaleAnimation;

  double _parallaxOffset = 0.0;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Ken Burns: scale 1.0 → 1.08 over 8s, then reverse, repeat forever.
    _kenBurnsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _kenBurnsController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.enableKenBurns) {
      _kenBurnsController.repeat(reverse: true);
    }

    if (widget.enableParallax && widget.scrollController != null) {
      widget.scrollController!.addListener(_updateParallax);
    }
  }

  void _updateParallax() {
    final renderBox =
        _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;

    final offsetInViewport =
        renderBox.localToGlobal(Offset.zero, ancestor: null).dy;
    // Shift at 30 % of the card's viewport position
    setState(() {
      _parallaxOffset = offsetInViewport * 0.3;
    });
  }

  @override
  void dispose() {
    _kenBurnsController.dispose();
    if (widget.enableParallax && widget.scrollController != null) {
      widget.scrollController!.removeListener(_updateParallax);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _cardKey,
      height: widget.height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Image layer (Ken Burns + parallax) ──────────
            _buildImageLayer(),

            // ── Gradient overlay (always present) ───────────
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

            // ── User overlay content ────────────────────────
            if (widget.overlay != null)
              Positioned.fill(child: widget.overlay!),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLayer() {
    Widget image = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: widget.height,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: TourPakColors.obsidian,
        highlightColor: TourPakColors.forestGreen,
        child: Container(color: TourPakColors.obsidian),
      ),
      errorWidget: (context, url, error) => Container(
        color: TourPakColors.forestGreen,
        child: const Center(
          child: Icon(
            Icons.terrain_rounded,
            color: TourPakColors.textSecondary,
            size: 48,
          ),
        ),
      ),
    );

    // Apply Ken Burns scale
    if (widget.enableKenBurns) {
      image = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: image,
      );
    }

    // Apply parallax translate
    if (widget.enableParallax) {
      image = Transform.translate(
        offset: Offset(0, _parallaxOffset),
        child: image,
      );
    }

    return Positioned.fill(child: image);
  }
}
