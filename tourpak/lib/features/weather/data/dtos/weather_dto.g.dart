// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherDtoImpl _$$WeatherDtoImplFromJson(Map<String, dynamic> json) =>
    _$WeatherDtoImpl(
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      condition: json['condition'] as String,
      iconCode: json['icon_code'] as String,
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['wind_speed'] as num).toDouble(),
    );

Map<String, dynamic> _$$WeatherDtoImplToJson(_$WeatherDtoImpl instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'condition': instance.condition,
      'icon_code': instance.iconCode,
      'humidity': instance.humidity,
      'wind_speed': instance.windSpeed,
    };

_$ForecastDtoImpl _$$ForecastDtoImplFromJson(Map<String, dynamic> json) =>
    _$ForecastDtoImpl(
      date: DateTime.parse(json['date'] as String),
      minTemp: (json['min_temp'] as num).toDouble(),
      maxTemp: (json['max_temp'] as num).toDouble(),
      condition: json['condition'] as String,
      iconCode: json['icon_code'] as String,
    );

Map<String, dynamic> _$$ForecastDtoImplToJson(_$ForecastDtoImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'min_temp': instance.minTemp,
      'max_temp': instance.maxTemp,
      'condition': instance.condition,
      'icon_code': instance.iconCode,
    };
