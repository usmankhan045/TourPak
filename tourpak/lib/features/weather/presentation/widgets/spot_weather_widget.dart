import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/weather.dart';
import '../notifiers/weather_notifier.dart';

// ══════════════════════════════════════════════════════════════
// WEATHER WIDGET — coords-based, 68px horizontal card
// ══════════════════════════════════════════════════════════════

/// Compact weather card for use on spot detail screens.
///
/// Takes raw [lat] / [lng] coordinates instead of a destination ID.
/// Shows current temperature, condition, humidity, and wind speed
/// in a 68px-tall horizontal card.
class WeatherWidget extends ConsumerWidget {
  final double lat;
  final double lng;

  const WeatherWidget({super.key, required this.lat, required this.lng});

  static const _bgColor = Color(0xFF0A2D4A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync =
        ref.watch(weatherByCoordsProvider((lat: lat, lng: lng)));

    return weatherAsync.when(
      loading: () => _buildShimmer(),
      error: (_, _) => _buildError(),
      data: (data) => data == null ? _buildError() : _buildCard(data.current),
    );
  }

  Widget _buildCard(Weather weather) {
    final iconUrl =
        'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png';
    final windKmh = (weather.windSpeed * 3.6).round();

    return Container(
      height: 68,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left: OWM icon
          SizedBox(
            width: 44,
            height: 44,
            child: CachedNetworkImage(
              imageUrl: iconUrl,
              fit: BoxFit.contain,
              placeholder: (_, _) => const SizedBox.shrink(),
              errorWidget: (_, _, _) => const Icon(
                Icons.wb_cloudy_rounded,
                color: Colors.white70,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Centre: temp + condition
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temp.round()}°C',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  weather.condition,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Right: humidity | wind
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\u{1F4A7} ${weather.humidity}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  '|',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white24,
                  ),
                ),
              ),
              Text(
                '\u{1F4A8} $windKmh km/h',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: _bgColor,
      highlightColor: const Color(0xFF143D5E),
      child: Container(
        height: 68,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      height: 68,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, color: Colors.white38, size: 20),
          const SizedBox(width: 8),
          Text(
            'Weather unavailable',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
