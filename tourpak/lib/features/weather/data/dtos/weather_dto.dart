import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_dto.freezed.dart';
part 'weather_dto.g.dart';

// ── Current weather DTO ────────────────────────────────────

@freezed
class WeatherDto with _$WeatherDto {
  const factory WeatherDto({
    required double temp,
    @JsonKey(name: 'feels_like') required double feelsLike,
    required String condition,
    @JsonKey(name: 'icon_code') required String iconCode,
    required int humidity,
    @JsonKey(name: 'wind_speed') required double windSpeed,
  }) = _WeatherDto;

  /// Parses the nested OpenWeatherMap current-weather API response.
  static WeatherDto fromApiResponse(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather =
        (json['weather'] as List).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;

    return WeatherDto(
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      condition: weather['main'] as String,
      iconCode: weather['icon'] as String,
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
    );
  }

  factory WeatherDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherDtoFromJson(json);
}

// ── Forecast day DTO ───────────────────────────────────────

@freezed
class ForecastDto with _$ForecastDto {
  const factory ForecastDto({
    required DateTime date,
    @JsonKey(name: 'min_temp') required double minTemp,
    @JsonKey(name: 'max_temp') required double maxTemp,
    required String condition,
    @JsonKey(name: 'icon_code') required String iconCode,
  }) = _ForecastDto;

  factory ForecastDto.fromJson(Map<String, dynamic> json) =>
      _$ForecastDtoFromJson(json);
}
