import 'package:flutter/material.dart';
import 'package:tourpak/core/theme/colors.dart';

/// Glassmorphism card following the TourPak Style Guard.
///
/// Uses a semi-transparent tinted surface with border for a glass effect
/// on dark backgrounds — without expensive BackdropFilter blur.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final Color tint;
  final double tintOpacity;
  final double borderOpacity;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 32,
    this.blurSigma = 20,
    this.tint = Colors.white,
    this.tintOpacity = 0.10,
    this.borderOpacity = 0.15,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  /// Dark variant using [TourPakColors.forestGreen] as the tint
  /// with a stronger opacity for deeper contrast on obsidian backgrounds.
  const GlassCard.dark({
    super.key,
    required this.child,
    this.borderRadius = 32,
    this.blurSigma = 20,
    this.borderOpacity = 0.15,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  })  : tint = TourPakColors.forestGreen,
        tintOpacity = 0.25;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: tintOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: borderOpacity),
          width: 1.0,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}
