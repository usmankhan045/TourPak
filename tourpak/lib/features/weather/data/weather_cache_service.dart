import 'package:tourpak/core/offline/hive_cache_manager.dart';
import 'package:tourpak/features/weather/data/dtos/weather_dto.dart';

/// Caches weather data in Hive with a 30-minute TTL.
class WeatherCacheService {
  static const _ttl = Duration(minutes: 30);

  final _currentCache = HiveCacheManager<Map<String, dynamic>>(
    boxName: 'weather_cache',
    ttl: _ttl,
  );

  final _forecastCache = HiveCacheManager<List<dynamic>>(
    boxName: 'forecast_cache',
    ttl: _ttl,
  );

  String _key(double lat, double lng) =>
      '${lat.toStringAsFixed(2)}_${lng.toStringAsFixed(2)}';

  // ── Current weather ─────────────────────────────────────

  Future<WeatherDto?> getCachedWeather(double lat, double lng) async {
    final key = _key(lat, lng);
    if (!await _currentCache.isValid(key)) return null;
    final data = await _currentCache.get(key);
    if (data == null) return null;
    return WeatherDto.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> cacheWeather(double lat, double lng, WeatherDto dto) async {
    await _currentCache.put(_key(lat, lng), dto.toJson());
  }

  // ── Forecast ────────────────────────────────────────────

  Future<List<ForecastDto>?> getCachedForecast(double lat, double lng) async {
    final key = _key(lat, lng);
    if (!await _forecastCache.isValid(key)) return null;
    final data = await _forecastCache.get(key);
    if (data == null) return null;
    return data
        .map((e) => ForecastDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> cacheForecast(
    double lat,
    double lng,
    List<ForecastDto> forecast,
  ) async {
    await _forecastCache.put(
      _key(lat, lng),
      forecast.map((d) => d.toJson()).toList(),
    );
  }

  // ── Clear ───────────────────────────────────────────────

  Future<void> clear() async {
    await _currentCache.clear();
    await _forecastCache.clear();
  }
}
