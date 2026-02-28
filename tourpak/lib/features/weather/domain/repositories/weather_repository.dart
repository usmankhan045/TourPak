import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/weather/domain/entities/weather.dart';

/// Contract for weather data operations.
abstract interface class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(double lat, double lng);
  Future<Either<Failure, List<ForecastDay>>> getForecast(double lat, double lng);
}
