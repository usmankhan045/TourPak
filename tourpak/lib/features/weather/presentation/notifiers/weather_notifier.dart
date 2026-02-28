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
final weatherProvider =
    FutureProvider.family<WeatherData, String>((ref, destinationId) async {
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
