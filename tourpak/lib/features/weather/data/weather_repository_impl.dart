import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/weather/data/weather_api_client.dart';
import 'package:tourpak/features/weather/data/weather_cache_service.dart';
import 'package:tourpak/features/weather/domain/entities/weather.dart';
import 'package:tourpak/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiClient _apiClient;
  final WeatherCacheService _cacheService;

  WeatherRepositoryImpl(this._apiClient, this._cacheService);

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(
    double lat,
    double lng,
  ) async {
    try {
      // Check cache first
      final cached = await _cacheService.getCachedWeather(lat, lng);
      if (cached != null) {
        return Right(Weather(
          temp: cached.temp,
          feelsLike: cached.feelsLike,
          condition: cached.condition,
          iconCode: cached.iconCode,
          humidity: cached.humidity,
          windSpeed: cached.windSpeed,
        ));
      }

      // Fetch from API
      final dto = await _apiClient.getCurrentWeather(lat, lng);
      await _cacheService.cacheWeather(lat, lng, dto);

      return Right(Weather(
        temp: dto.temp,
        feelsLike: dto.feelsLike,
        condition: dto.condition,
        iconCode: dto.iconCode,
        humidity: dto.humidity,
        windSpeed: dto.windSpeed,
      ));
    } catch (e) {
      // Fall back to stale cache on error
      final cached = await _cacheService.getCachedWeather(lat, lng);
      if (cached != null) {
        return Right(Weather(
          temp: cached.temp,
          feelsLike: cached.feelsLike,
          condition: cached.condition,
          iconCode: cached.iconCode,
          humidity: cached.humidity,
          windSpeed: cached.windSpeed,
        ));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ForecastDay>>> getForecast(
    double lat,
    double lng,
  ) async {
    try {
      // Check cache first
      final cached = await _cacheService.getCachedForecast(lat, lng);
      if (cached != null) {
        return Right(cached
            .map((dto) => ForecastDay(
                  date: dto.date,
                  minTemp: dto.minTemp,
                  maxTemp: dto.maxTemp,
                  condition: dto.condition,
                  iconCode: dto.iconCode,
                ))
            .toList());
      }

      // Fetch from API
      final dtos = await _apiClient.getForecast(lat, lng);
      await _cacheService.cacheForecast(lat, lng, dtos);

      return Right(dtos
          .map((dto) => ForecastDay(
                date: dto.date,
                minTemp: dto.minTemp,
                maxTemp: dto.maxTemp,
                condition: dto.condition,
                iconCode: dto.iconCode,
              ))
          .toList());
    } catch (e) {
      final cached = await _cacheService.getCachedForecast(lat, lng);
      if (cached != null) {
        return Right(cached
            .map((dto) => ForecastDay(
                  date: dto.date,
                  minTemp: dto.minTemp,
                  maxTemp: dto.maxTemp,
                  condition: dto.condition,
                  iconCode: dto.iconCode,
                ))
            .toList());
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
