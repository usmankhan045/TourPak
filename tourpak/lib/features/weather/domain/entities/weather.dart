import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required double temp,
    required double feelsLike,
    required String condition,
    required String iconCode,
    required int humidity,
    required double windSpeed,
  }) = _Weather;
}

@freezed
class ForecastDay with _$ForecastDay {
  const factory ForecastDay({
    required DateTime date,
    required double minTemp,
    required double maxTemp,
    required String condition,
    required String iconCode,
  }) = _ForecastDay;
}
