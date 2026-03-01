import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../destinations/presentation/notifiers/destinations_notifier.dart';
import '../../domain/entities/weather.dart';
import '../notifiers/weather_notifier.dart';
import '../widgets/weather_icon.dart';

// ══════════════════════════════════════════════════════════════
// WEATHER DETAIL SCREEN
// ══════════════════════════════════════════════════════════════

class WeatherDetailScreen extends ConsumerWidget {
  final String destinationId;

  /// Optional spot-specific coordinates. When provided, weather is
  /// fetched for these coordinates instead of the destination's.
  final double? lat;
  final double? lng;
  final String? locationName;

  const WeatherDetailScreen({
    super.key,
    required this.destinationId,
    this.lat,
    this.lng,
    this.locationName,
  });

  bool get _hasCoords => lat != null && lng != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use spot-specific coords when available, otherwise destination's.
    final asyncWeather = _hasCoords
        ? ref.watch(
            weatherByCoordsFullProvider((lat: lat!, lng: lng!)))
        : ref.watch(weatherProvider(destinationId));

    final topInset = MediaQuery.paddingOf(context).top;

    // Resolve display name: explicit locationName > destination name
    String displayName = locationName ?? '';
    if (displayName.isEmpty) {
      final asyncDest = ref.watch(destinationByIdProvider(destinationId));
      displayName = asyncDest.whenOrNull(data: (d) => d.name) ?? '';
    }

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: asyncWeather.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: TourPakColors.goldAction),
        ),
        error: (e, _) => ErrorDisplay(
          message: 'Failed to load weather data.',
          onRetry: () {
            if (_hasCoords) {
              ref.invalidate(
                  weatherByCoordsFullProvider((lat: lat!, lng: lng!)));
            } else {
              ref.invalidate(weatherProvider(destinationId));
            }
          },
        ),
        data: (data) => _WeatherContent(
          data: data,
          destinationName: displayName,
          topInset: topInset,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// WEATHER CONTENT
// ══════════════════════════════════════════════════════════════

class _WeatherContent extends StatelessWidget {
  final WeatherData data;
  final String destinationName;
  final double topInset;

  const _WeatherContent({
    required this.data,
    required this.destinationName,
    required this.topInset,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          _Header(destinationName: destinationName),
          const SizedBox(height: 24),

          // ── Current weather card ────────────────────────────
          _CurrentWeatherCard(weather: data.current),
          const SizedBox(height: 20),

          // ── Traveler metrics grid ───────────────────────────
          _TravelerMetrics(weather: data.current),
          const SizedBox(height: 24),

          // ── Forecast section ────────────────────────────────
          if (data.forecast.isNotEmpty) ...[
            Text(
              '5-Day Forecast',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            // Horizontal scroll forecast chips
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.forecast.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) =>
                    _ForecastChip(forecast: data.forecast[i]),
              ),
            ),
            const SizedBox(height: 20),

            // Detailed forecast list
            ...data.forecast.map((f) => _ForecastListItem(forecast: f)),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// HEADER
// ══════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  final String destinationName;

  const _Header({required this.destinationName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TourPakColors.forestGreen.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: TourPakColors.textPrimary, size: 20),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.textPrimary,
                ),
              ),
              if (destinationName.isNotEmpty)
                Text(
                  destinationName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: TourPakColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// CURRENT WEATHER CARD
// ══════════════════════════════════════════════════════════════

class _CurrentWeatherCard extends StatelessWidget {
  final Weather weather;

  const _CurrentWeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TourPakColors.forestGreen.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: TourPakColors.goldAction.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
            children: [
              // Icon + Temperature
              Text(
                weatherIconEmoji(weather.iconCode),
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 8),
              Text(
                '${weather.temp.round()}°C',
                style: GoogleFonts.inter(
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                weather.condition,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: TourPakColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Feels like ${weather.feelsLike.round()}°C',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TourPakColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// TRAVELER METRICS GRID (2×2)
// ══════════════════════════════════════════════════════════════

class _TravelerMetrics extends StatelessWidget {
  final Weather weather;

  const _TravelerMetrics({required this.weather});

  String _windLabel(double speed) {
    if (speed < 3) return 'Light';
    if (speed < 8) return 'Moderate';
    if (speed < 14) return 'Strong';
    return 'Very Strong';
  }

  String _humidityLabel(int humidity) {
    if (humidity < 30) return 'Dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 80) return 'Humid';
    return 'Very Humid';
  }

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        icon: Icons.air_rounded,
        label: 'Wind',
        value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
        desc: _windLabel(weather.windSpeed),
        color: TourPakColors.goldAction,
      ),
      (
        icon: Icons.water_drop_rounded,
        label: 'Humidity',
        value: '${weather.humidity}%',
        desc: _humidityLabel(weather.humidity),
        color: const Color(0xFF60A5FA),
      ),
      (
        icon: Icons.thermostat_rounded,
        label: 'Feels Like',
        value: '${weather.feelsLike.round()}°C',
        desc: 'Real feel',
        color: const Color(0xFFF97316),
      ),
      (
        icon: Icons.wb_cloudy_rounded,
        label: 'Condition',
        value: weather.condition,
        desc: 'Current',
        color: const Color(0xFF34D399),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Traveler Metrics',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: TourPakColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: metrics.map((m) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    TourPakColors.forestGreen.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(m.icon, color: m.color, size: 22),
                  const SizedBox(height: 8),
                  Text(
                    m.label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: TourPakColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    m.value,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: TourPakColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    m.desc,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: TourPakColors.textSecondary
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// FORECAST CHIP (horizontal scroll)
// ══════════════════════════════════════════════════════════════

class _ForecastChip extends StatelessWidget {
  final ForecastDay forecast;

  const _ForecastChip({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final dayName = _shortDayName(forecast.date.weekday);

    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: TourPakColors.forestGreen.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
          SizedBox(
            height: 32,
            child: Center(
              child: Text(
                weatherIconEmoji(forecast.iconCode),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${forecast.maxTemp.round()}°',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: TourPakColors.textPrimary,
            ),
          ),
          Text(
            '${forecast.minTemp.round()}°',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: TourPakColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// FORECAST LIST ITEM (vertical list)
// ══════════════════════════════════════════════════════════════

class _ForecastListItem extends StatelessWidget {
  final ForecastDay forecast;

  const _ForecastListItem({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final dayName = _fullDayName(forecast.date.weekday);
    final dateStr =
        '${forecast.date.day}/${forecast.date.month}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: TourPakColors.forestGreen.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Day name + date
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: TourPakColors.textPrimary,
                    ),
                  ),
                  Text(
                    dateStr,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: TourPakColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Weather icon
            Text(
              weatherIconEmoji(forecast.iconCode),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),

            // Condition
            Expanded(
              child: Text(
                forecast.condition,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: TourPakColors.textSecondary,
                ),
              ),
            ),

            // Min/Max
            Text(
              '${forecast.minTemp.round()}° / ${forecast.maxTemp.round()}°',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TourPakColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────

String _shortDayName(int weekday) {
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[weekday - 1];
}

String _fullDayName(int weekday) {
  const names = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];
  return names[weekday - 1];
}
