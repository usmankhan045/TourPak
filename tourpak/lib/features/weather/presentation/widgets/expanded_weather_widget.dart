import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourpak/core/theme/colors.dart';
import 'package:tourpak/features/weather/domain/entities/weather.dart';
import 'package:tourpak/features/weather/presentation/notifiers/weather_notifier.dart';
import 'package:tourpak/features/weather/presentation/widgets/weather_icon.dart';

/// Expanded weather panel for destination detail pages.
///
/// Shows:
/// - Current weather row (icon, temp, condition, humidity, wind).
/// - Horizontal-scroll forecast day chips.
/// - Best visiting months with gold highlight.
class ExpandedWeatherWidget extends ConsumerWidget {
  final String destinationId;

  /// The destination's recommended months, e.g. `['June', 'July', 'August']`.
  final List<String> bestMonths;

  const ExpandedWeatherWidget({
    super.key,
    required this.destinationId,
    this.bestMonths = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider(destinationId));

    return weatherAsync.when(
      data: (data) => _buildContent(data),
      loading: _buildLoading,
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  // ── Current weather row ──────────────────────────────────

  Widget _buildContent(WeatherData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current weather
        _buildCurrentRow(data.current),
        const SizedBox(height: 16),

        // Forecast chips
        if (data.forecast.isNotEmpty) ...[
          Text(
            'Forecast',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: TourPakColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: data.forecast.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => _buildDayChip(data.forecast[i]),
            ),
          ),
        ],

        // Best visiting months
        if (bestMonths.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildBestMonths(),
        ],
      ],
    );
  }

  Widget _buildCurrentRow(Weather weather) {
    return Row(
      children: [
        // Icon
        Text(
          weatherIconEmoji(weather.iconCode),
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(width: 10),

        // Temp + condition
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weather.temp.round()}°C',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
            ),
            Text(
              weather.condition,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: TourPakColors.textSecondary,
              ),
            ),
          ],
        ),

        const Spacer(),

        // Details column
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Feels ${weather.feelsLike.round()}°',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: TourPakColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('\u{1F4A7}', style: TextStyle(fontSize: 11)), // 💧
                const SizedBox(width: 2),
                Text(
                  '${weather.humidity}%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: TourPakColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('\u{1F4A8}', style: TextStyle(fontSize: 11)), // 💨
                const SizedBox(width: 2),
                Text(
                  '${weather.windSpeed.toStringAsFixed(1)} m/s',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: TourPakColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ── Forecast day chip ────────────────────────────────────

  Widget _buildDayChip(ForecastDay day) {
    final dayName = _shortDayName(day.date.weekday);

    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: TourPakColors.forestGreen.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: TourPakColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weatherIconEmoji(day.iconCode),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            '${day.minTemp.round()}/${day.maxTemp.round()}°',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: TourPakColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Best visiting months ─────────────────────────────────

  Widget _buildBestMonths() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Best months to visit',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: TourPakColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: bestMonths
              .map(
                (month) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TourPakColors.goldAction.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: TourPakColors.goldAction.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    month,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: TourPakColors.goldAction,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ── Loading skeleton ─────────────────────────────────────

  Widget _buildLoading() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: TourPakColors.forestGreen,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 80,
          height: 14,
          decoration: BoxDecoration(
            color: TourPakColors.forestGreen,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ],
    );
  }

  // ── Helpers ──────────────────────────────────────────────

  String _shortDayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }
}
