import 'package:flutter/material.dart';

/// TourPak Style Guard - Brand Color Palette
class TourPakColors {
  TourPakColors._();

  // Core Background
  static const Color obsidian = Color(0xFF0F1711);        // main background
  static const Color forestGreen = Color(0xFF1B3022);     // primary brand
  static const Color forestLight = Color(0xFF2D5A3D);     // card surfaces

  // Gold / Accent
  static const Color goldAction = Color(0xFFFFD700);      // CTAs and active states
  static const Color goldMuted = Color(0xFFD4A853);       // secondary gold

  // Text
  static const Color textPrimary = Color(0xFFF0EDE8);     // warm off-white
  static const Color textSecondary = Color(0xFF9E9B94);   // warm gray

  // Glass
  static const Color glass = Color(0x1AFFFFFF);           // 10% white for glassmorphism

  // Semantic
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Derived helpers
  static const Color shimmerBase = Color(0xFF1B3022);
  static const Color shimmerHighlight = Color(0xFF2D5A3D);
  static const Color divider = Color(0xFF2D5A3D);
  static const Color border = Color(0xFF2D5A3D);
}
