import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourpak/features/destinations/presentation/notifiers/destinations_notifier.dart';
import 'package:tourpak/features/weather/data/weather_api_client.dart';
import 'package:tourpak/features/weather/data/weather_cache_service.dart';
import 'package:tourpak/features/weather/data/weather_repository_impl.dart';
import 'package:tourpak/features/weather/domain/entities/weather.dart';
import 'package:tourpak/features/weather/domain/repositories/weather_repository.dart';

// ── Weather data bundle ────────────────────────────────────

class WeatherData {
  final Weather current;
  final List<ForecastDay> forecast;

  const WeatherData({required this.current, required this.forecast});
}

// ── Provider chain ─────────────────────────────────────────

final _weatherApiClientProvider = Provider<WeatherApiClient>((ref) {
  return WeatherApiClient();
});

final _weatherCacheServiceProvider = Provider<WeatherCacheService>((ref) {
  return WeatherCacheService();
});

final _weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    ref.watch(_weatherApiClientProvider),
    ref.watch(_weatherCacheServiceProvider),
  );
});

// ── Weather for a destination ──────────────────────────────

/// Fetches current weather + forecast for a destination.
///
/// Usage: `ref.watch(weatherProvider(destinationId))`
///
/// The provider resolves the destination's lat/lng from
/// [destinationByIdProvider], then fetches weather data.
/// Uses autoDispose so weather re-fetches when the screen
/// is revisited (Hive cache still prevents unnecessary API calls
/// within the 30-minute TTL).
final weatherProvider = FutureProvider.autoDispose
    .family<WeatherData, String>((ref, destinationId) async {
  // Keep alive for 5 minutes so quick back-and-forth doesn't re-fetch
  final link = ref.keepAlive();
  Future.delayed(const Duration(minutes: 5), link.close);

  final destination =
      await ref.watch(destinationByIdProvider(destinationId).future);

  final lat = destination.latitude;
  final lng = destination.longitude;
  if (lat == null || lng == null) {
    throw Exception('Destination has no coordinates');
  }

  final repo = ref.watch(_weatherRepositoryProvider);

  final weatherResult = await repo.getCurrentWeather(lat, lng);
  final forecastResult = await repo.getForecast(lat, lng);

  final weather = weatherResult.fold(
    (failure) => throw Exception(failure.message),
    (w) => w,
  );

  final forecast = forecastResult.fold(
    (failure) => <ForecastDay>[],
    (f) => f,
  );

  return WeatherData(current: weather, forecast: forecast);
});

// ── Weather by raw coordinates ─────────────────────────────

/// Fetches current weather for a given lat/lng pair using the
/// in-memory cached API client.  Returns `null` on any error.
///
/// Usage: `ref.watch(weatherByCoordsProvider((lat: 35.2, lng: 72.3)))`
final weatherByCoordsProvider = FutureProvider.autoDispose.family<WeatherData?,
    ({double lat, double lng})>((ref, coords) async {
  // Keep alive for 5 minutes
  final link = ref.keepAlive();
  Future.delayed(const Duration(minutes: 5), link.close);

  final apiClient = ref.watch(_weatherApiClientProvider);
  final dto =
      await apiClient.getWeatherByCoordsCached(coords.lat, coords.lng);
  if (dto == null) return null;
  return WeatherData(
    current: Weather(
      temp: dto.temp,
      feelsLike: dto.feelsLike,
      condition: dto.condition,
      iconCode: dto.iconCode,
      humidity: dto.humidity,
      windSpeed: dto.windSpeed,
    ),
    forecast: [],
  );
});

// ── Full weather by raw coordinates (current + forecast) ────

/// Fetches current weather + 5-day forecast for raw lat/lng.
/// Used by the weather detail screen when opened from a spot.
///
/// Usage: `ref.watch(weatherByCoordsFullProvider((lat: 35.2, lng: 72.3)))`
final weatherByCoordsFullProvider = FutureProvider.autoDispose
    .family<WeatherData, ({double lat, double lng})>((ref, coords) async {
  final link = ref.keepAlive();
  Future.delayed(const Duration(minutes: 5), link.close);

  final repo = ref.watch(_weatherRepositoryProvider);

  final weatherResult = await repo.getCurrentWeather(coords.lat, coords.lng);
  final forecastResult = await repo.getForecast(coords.lat, coords.lng);

  final weather = weatherResult.fold(
    (failure) => throw Exception(failure.message),
    (w) => w,
  );

  final forecast = forecastResult.fold(
    (failure) => <ForecastDay>[],
    (f) => f,
  );

  return WeatherData(current: weather, forecast: forecast);
});
