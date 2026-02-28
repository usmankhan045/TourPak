import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tourpak/features/weather/data/dtos/weather_dto.dart';

/// Dio client that talks to the OpenWeatherMap API.
class WeatherApiClient {
  final Dio _dio;
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherApiClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ));

  String get _apiKey => dotenv.env['OPENWEATHER_API_KEY']!;

  /// Fetches current weather for [lat], [lng].
  Future<WeatherDto> getCurrentWeather(double lat, double lng) async {
    final response = await _dio.get(
      '/weather',
      queryParameters: {
        'lat': lat,
        'lon': lng,
        'appid': _apiKey,
        'units': 'metric',
      },
    );
    return WeatherDto.fromApiResponse(response.data as Map<String, dynamic>);
  }

  /// Fetches a multi-day forecast for [lat], [lng].
  ///
  /// The free `/forecast` endpoint returns 5-day / 3-hour data.
  /// This method aggregates the 3-hour entries into daily summaries
  /// (min temp, max temp, dominant condition).
  Future<List<ForecastDto>> getForecast(double lat, double lng) async {
    final response = await _dio.get(
      '/forecast',
      queryParameters: {
        'lat': lat,
        'lon': lng,
        'appid': _apiKey,
        'units': 'metric',
      },
    );

    final list = (response.data as Map<String, dynamic>)['list'] as List;
    return _aggregateDaily(list.cast<Map<String, dynamic>>());
  }

  /// Groups 3-hour entries by date and picks min/max temp + midday icon.
  List<ForecastDto> _aggregateDaily(List<Map<String, dynamic>> entries) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final entry in entries) {
      final dt =
          DateTime.fromMillisecondsSinceEpoch((entry['dt'] as int) * 1000);
      final dateKey = '${dt.year}-${dt.month}-${dt.day}';
      grouped.putIfAbsent(dateKey, () => []).add(entry);
    }

    // Skip the current partial day (first key) if we have enough data.
    final dayKeys = grouped.keys.toList();
    if (dayKeys.length > 1) dayKeys.removeAt(0);

    return dayKeys.map((key) {
      final dayEntries = grouped[key]!;

      double minTemp = double.infinity;
      double maxTemp = double.negativeInfinity;

      for (final e in dayEntries) {
        final main = e['main'] as Map<String, dynamic>;
        final tMin = (main['temp_min'] as num).toDouble();
        final tMax = (main['temp_max'] as num).toDouble();
        if (tMin < minTemp) minTemp = tMin;
        if (tMax > maxTemp) maxTemp = tMax;
      }

      // Pick the midday (12:00) entry for the representative icon,
      // falling back to the middle entry if 12:00 isn't available.
      final middayEntry = dayEntries.firstWhere(
        (e) {
          final dt = DateTime.fromMillisecondsSinceEpoch(
              (e['dt'] as int) * 1000);
          return dt.hour >= 11 && dt.hour <= 14;
        },
        orElse: () => dayEntries[dayEntries.length ~/ 2],
      );

      final weather =
          (middayEntry['weather'] as List).first as Map<String, dynamic>;
      final dt = DateTime.fromMillisecondsSinceEpoch(
          (dayEntries.first['dt'] as int) * 1000);

      return ForecastDto(
        date: DateTime(dt.year, dt.month, dt.day),
        minTemp: minTemp,
        maxTemp: maxTemp,
        condition: weather['main'] as String,
        iconCode: weather['icon'] as String,
      );
    }).toList();
  }
}
