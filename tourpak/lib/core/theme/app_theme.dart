import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

/// TourPak Style Guard - App Theme
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: TourPakColors.obsidian,
      colorScheme: const ColorScheme.dark(
        primary: TourPakColors.goldAction,
        primaryContainer: TourPakColors.forestGreen,
        secondary: TourPakColors.goldMuted,
        secondaryContainer: TourPakColors.forestLight,
        surface: TourPakColors.forestGreen,
        error: TourPakColors.errorRed,
        onPrimary: TourPakColors.obsidian,
        onSecondary: TourPakColors.obsidian,
        onSurface: TourPakColors.textPrimary,
        onError: Colors.white,
        outline: TourPakColors.border,
      ),

      // AppBar – transparent, no elevation
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: TourPakColors.textPrimary,
        titleTextStyle: TourPakTextStyles.headlineMedium,
        surfaceTintColor: Colors.transparent,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TourPakTextStyles.displayLarge,
        displayMedium: TourPakTextStyles.displayMedium,
        displaySmall: TourPakTextStyles.displayMedium,
        headlineLarge: TourPakTextStyles.headlineLarge,
        headlineMedium: TourPakTextStyles.headlineMedium,
        headlineSmall: TourPakTextStyles.headlineSmall,
        titleLarge: TourPakTextStyles.titleLarge,
        titleMedium: TourPakTextStyles.titleMedium,
        titleSmall: TourPakTextStyles.titleSmall,
        bodyLarge: TourPakTextStyles.bodyLarge,
        bodyMedium: TourPakTextStyles.bodyMedium,
        bodySmall: TourPakTextStyles.bodySmall,
        labelLarge: TourPakTextStyles.labelLarge,
        labelMedium: TourPakTextStyles.labelMedium,
        labelSmall: TourPakTextStyles.labelSmall,
      ),

      // Elevated Button – gold CTA
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TourPakColors.goldAction,
          foregroundColor: TourPakColors.obsidian,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TourPakTextStyles.button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TourPakColors.goldAction,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: TourPakColors.goldAction, width: 1.5),
          textStyle: TourPakTextStyles.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TourPakColors.goldAction,
          textStyle: TourPakTextStyles.button,
        ),
      ),

      // Input Decoration – dark fields, gold focus border
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TourPakColors.forestGreen,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TourPakTextStyles.bodyMedium.copyWith(
          color: TourPakColors.textSecondary,
        ),
        labelStyle: TourPakTextStyles.labelLarge,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TourPakColors.forestLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TourPakColors.goldAction, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TourPakColors.errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TourPakColors.errorRed, width: 2),
        ),
      ),

      // Card – forestLight background, 32px radius
      cardTheme: CardThemeData(
        elevation: 0,
        color: TourPakColors.forestLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      // Bottom Navigation – obsidian bg, gold selected
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: TourPakColors.obsidian,
        selectedItemColor: TourPakColors.goldAction,
        unselectedItemColor: TourPakColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TourPakTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: TourPakColors.goldAction,
        ),
        unselectedLabelStyle: TourPakTextStyles.labelSmall,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: TourPakColors.forestGreen,
        selectedColor: TourPakColors.goldAction,
        labelStyle: TourPakTextStyles.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: TourPakColors.divider,
        thickness: 0.5,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: TourPakColors.textPrimary,
        size: 24,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: TourPakColors.goldAction,
        foregroundColor: TourPakColors.obsidian,
        elevation: 4,
      ),
    );
  }
}
