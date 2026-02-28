import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourpak/core/theme/colors.dart';
import 'package:tourpak/features/weather/domain/entities/weather.dart';
import 'package:tourpak/features/weather/presentation/notifiers/weather_notifier.dart';
import 'package:tourpak/features/weather/presentation/widgets/weather_icon.dart';

/// Compact weather chip for destination cards.
///
/// Shows a small dark-glass pill with the weather icon, temperature,
/// and condition text.
class CompactWeatherWidget extends ConsumerWidget {
  final String destinationId;

  const CompactWeatherWidget({super.key, required this.destinationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider(destinationId));

    return weatherAsync.when(
      data: (data) => _buildChip(data.current),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildChip(Weather weather) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: TourPakColors.forestGreen.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weatherIconEmoji(weather.iconCode),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              Text(
                '${weather.temp.round()}°',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                weather.condition,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: TourPakColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
