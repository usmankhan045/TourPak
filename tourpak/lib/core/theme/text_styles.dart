import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// TourPak Style Guard - Typography
///
/// Display / Titles → Playfair Display (serif, editorial feel)
/// Body / UI        → Inter (clean, highly legible)
class TourPakTextStyles {
  TourPakTextStyles._();

  // ── Display ──────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: TourPakColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: TourPakColors.textPrimary,
  );

  // ── Title ────────────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: TourPakColors.textPrimary,
  );

  // ── Body ─────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: TourPakColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TourPakColors.textSecondary,
    height: 1.5,
  );

  // ── Label / Gold CTA ────────────────────────────────────
  static TextStyle labelGold = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: TourPakColors.goldAction,
    letterSpacing: 1.2,
  );

  // ── Caption ──────────────────────────────────────────────
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: TourPakColors.textSecondary,
  );

  // ── Derived helpers used by ThemeData ────────────────────
  static TextStyle headlineLarge = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: TourPakColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: TourPakColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: TourPakColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: TourPakColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: TourPakColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: TourPakColors.textSecondary,
    height: 1.4,
  );

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: TourPakColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: TourPakColors.textSecondary,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: TourPakColors.textSecondary,
    letterSpacing: 0.5,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}
