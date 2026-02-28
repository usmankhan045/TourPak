// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeatherDto _$WeatherDtoFromJson(Map<String, dynamic> json) {
  return _WeatherDto.fromJson(json);
}

/// @nodoc
mixin _$WeatherDto {
  double get temp => throw _privateConstructorUsedError;
  @JsonKey(name: 'feels_like')
  double get feelsLike => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_code')
  String get iconCode => throw _privateConstructorUsedError;
  int get humidity => throw _privateConstructorUsedError;
  @JsonKey(name: 'wind_speed')
  double get windSpeed => throw _privateConstructorUsedError;

  /// Serializes this WeatherDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherDtoCopyWith<WeatherDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherDtoCopyWith<$Res> {
  factory $WeatherDtoCopyWith(
    WeatherDto value,
    $Res Function(WeatherDto) then,
  ) = _$WeatherDtoCopyWithImpl<$Res, WeatherDto>;
  @useResult
  $Res call({
    double temp,
    @JsonKey(name: 'feels_like') double feelsLike,
    String condition,
    @JsonKey(name: 'icon_code') String iconCode,
    int humidity,
    @JsonKey(name: 'wind_speed') double windSpeed,
  });
}

/// @nodoc
class _$WeatherDtoCopyWithImpl<$Res, $Val extends WeatherDto>
    implements $WeatherDtoCopyWith<$Res> {
  _$WeatherDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temp = null,
    Object? feelsLike = null,
    Object? condition = null,
    Object? iconCode = null,
    Object? humidity = null,
    Object? windSpeed = null,
  }) {
    return _then(
      _value.copyWith(
            temp: null == temp
                ? _value.temp
                : temp // ignore: cast_nullable_to_non_nullable
                      as double,
            feelsLike: null == feelsLike
                ? _value.feelsLike
                : feelsLike // ignore: cast_nullable_to_non_nullable
                      as double,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
            iconCode: null == iconCode
                ? _value.iconCode
                : iconCode // ignore: cast_nullable_to_non_nullable
                      as String,
            humidity: null == humidity
                ? _value.humidity
                : humidity // ignore: cast_nullable_to_non_nullable
                      as int,
            windSpeed: null == windSpeed
                ? _value.windSpeed
                : windSpeed // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherDtoImplCopyWith<$Res>
    implements $WeatherDtoCopyWith<$Res> {
  factory _$$WeatherDtoImplCopyWith(
    _$WeatherDtoImpl value,
    $Res Function(_$WeatherDtoImpl) then,
  ) = __$$WeatherDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double temp,
    @JsonKey(name: 'feels_like') double feelsLike,
    String condition,
    @JsonKey(name: 'icon_code') String iconCode,
    int humidity,
    @JsonKey(name: 'wind_speed') double windSpeed,
  });
}

/// @nodoc
class __$$WeatherDtoImplCopyWithImpl<$Res>
    extends _$WeatherDtoCopyWithImpl<$Res, _$WeatherDtoImpl>
    implements _$$WeatherDtoImplCopyWith<$Res> {
  __$$WeatherDtoImplCopyWithImpl(
    _$WeatherDtoImpl _value,
    $Res Function(_$WeatherDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temp = null,
    Object? feelsLike = null,
    Object? condition = null,
    Object? iconCode = null,
    Object? humidity = null,
    Object? windSpeed = null,
  }) {
    return _then(
      _$WeatherDtoImpl(
        temp: null == temp
            ? _value.temp
            : temp // ignore: cast_nullable_to_non_nullable
                  as double,
        feelsLike: null == feelsLike
            ? _value.feelsLike
            : feelsLike // ignore: cast_nullable_to_non_nullable
                  as double,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
        iconCode: null == iconCode
            ? _value.iconCode
            : iconCode // ignore: cast_nullable_to_non_nullable
                  as String,
        humidity: null == humidity
            ? _value.humidity
            : humidity // ignore: cast_nullable_to_non_nullable
                  as int,
        windSpeed: null == windSpeed
            ? _value.windSpeed
            : windSpeed // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherDtoImpl implements _WeatherDto {
  const _$WeatherDtoImpl({
    required this.temp,
    @JsonKey(name: 'feels_like') required this.feelsLike,
    required this.condition,
    @JsonKey(name: 'icon_code') required this.iconCode,
    required this.humidity,
    @JsonKey(name: 'wind_speed') required this.windSpeed,
  });

  factory _$WeatherDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherDtoImplFromJson(json);

  @override
  final double temp;
  @override
  @JsonKey(name: 'feels_like')
  final double feelsLike;
  @override
  final String condition;
  @override
  @JsonKey(name: 'icon_code')
  final String iconCode;
  @override
  final int humidity;
  @override
  @JsonKey(name: 'wind_speed')
  final double windSpeed;

  @override
  String toString() {
    return 'WeatherDto(temp: $temp, feelsLike: $feelsLike, condition: $condition, iconCode: $iconCode, humidity: $humidity, windSpeed: $windSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherDtoImpl &&
            (identical(other.temp, temp) || other.temp == temp) &&
            (identical(other.feelsLike, feelsLike) ||
                other.feelsLike == feelsLike) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.iconCode, iconCode) ||
                other.iconCode == iconCode) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.windSpeed, windSpeed) ||
                other.windSpeed == windSpeed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    temp,
    feelsLike,
    condition,
    iconCode,
    humidity,
    windSpeed,
  );

  /// Create a copy of WeatherDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherDtoImplCopyWith<_$WeatherDtoImpl> get copyWith =>
      __$$WeatherDtoImplCopyWithImpl<_$WeatherDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherDtoImplToJson(this);
  }
}

abstract class _WeatherDto implements WeatherDto {
  const factory _WeatherDto({
    required final double temp,
    @JsonKey(name: 'feels_like') required final double feelsLike,
    required final String condition,
    @JsonKey(name: 'icon_code') required final String iconCode,
    required final int humidity,
    @JsonKey(name: 'wind_speed') required final double windSpeed,
  }) = _$WeatherDtoImpl;

  factory _WeatherDto.fromJson(Map<String, dynamic> json) =
      _$WeatherDtoImpl.fromJson;

  @override
  double get temp;
  @override
  @JsonKey(name: 'feels_like')
  double get feelsLike;
  @override
  String get condition;
  @override
  @JsonKey(name: 'icon_code')
  String get iconCode;
  @override
  int get humidity;
  @override
  @JsonKey(name: 'wind_speed')
  double get windSpeed;

  /// Create a copy of WeatherDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherDtoImplCopyWith<_$WeatherDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ForecastDto _$ForecastDtoFromJson(Map<String, dynamic> json) {
  return _ForecastDto.fromJson(json);
}

/// @nodoc
mixin _$ForecastDto {
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_temp')
  double get minTemp => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_temp')
  double get maxTemp => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_code')
  String get iconCode => throw _privateConstructorUsedError;

  /// Serializes this ForecastDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForecastDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForecastDtoCopyWith<ForecastDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastDtoCopyWith<$Res> {
  factory $ForecastDtoCopyWith(
    ForecastDto value,
    $Res Function(ForecastDto) then,
  ) = _$ForecastDtoCopyWithImpl<$Res, ForecastDto>;
  @useResult
  $Res call({
    DateTime date,
    @JsonKey(name: 'min_temp') double minTemp,
    @JsonKey(name: 'max_temp') double maxTemp,
    String condition,
    @JsonKey(name: 'icon_code') String iconCode,
  });
}

/// @nodoc
class _$ForecastDtoCopyWithImpl<$Res, $Val extends ForecastDto>
    implements $ForecastDtoCopyWith<$Res> {
  _$ForecastDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForecastDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? minTemp = null,
    Object? maxTemp = null,
    Object? condition = null,
    Object? iconCode = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            minTemp: null == minTemp
                ? _value.minTemp
                : minTemp // ignore: cast_nullable_to_non_nullable
                      as double,
            maxTemp: null == maxTemp
                ? _value.maxTemp
                : maxTemp // ignore: cast_nullable_to_non_nullable
                      as double,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
            iconCode: null == iconCode
                ? _value.iconCode
                : iconCode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForecastDtoImplCopyWith<$Res>
    implements $ForecastDtoCopyWith<$Res> {
  factory _$$ForecastDtoImplCopyWith(
    _$ForecastDtoImpl value,
    $Res Function(_$ForecastDtoImpl) then,
  ) = __$$ForecastDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    @JsonKey(name: 'min_temp') double minTemp,
    @JsonKey(name: 'max_temp') double maxTemp,
    String condition,
    @JsonKey(name: 'icon_code') String iconCode,
  });
}

/// @nodoc
class __$$ForecastDtoImplCopyWithImpl<$Res>
    extends _$ForecastDtoCopyWithImpl<$Res, _$ForecastDtoImpl>
    implements _$$ForecastDtoImplCopyWith<$Res> {
  __$$ForecastDtoImplCopyWithImpl(
    _$ForecastDtoImpl _value,
    $Res Function(_$ForecastDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForecastDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? minTemp = null,
    Object? maxTemp = null,
    Object? condition = null,
    Object? iconCode = null,
  }) {
    return _then(
      _$ForecastDtoImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        minTemp: null == minTemp
            ? _value.minTemp
            : minTemp // ignore: cast_nullable_to_non_nullable
                  as double,
        maxTemp: null == maxTemp
            ? _value.maxTemp
            : maxTemp // ignore: cast_nullable_to_non_nullable
                  as double,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
        iconCode: null == iconCode
            ? _value.iconCode
            : iconCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ForecastDtoImpl implements _ForecastDto {
  const _$ForecastDtoImpl({
    required this.date,
    @JsonKey(name: 'min_temp') required this.minTemp,
    @JsonKey(name: 'max_temp') required this.maxTemp,
    required this.condition,
    @JsonKey(name: 'icon_code') required this.iconCode,
  });

  factory _$ForecastDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForecastDtoImplFromJson(json);

  @override
  final DateTime date;
  @override
  @JsonKey(name: 'min_temp')
  final double minTemp;
  @override
  @JsonKey(name: 'max_temp')
  final double maxTemp;
  @override
  final String condition;
  @override
  @JsonKey(name: 'icon_code')
  final String iconCode;

  @override
  String toString() {
    return 'ForecastDto(date: $date, minTemp: $minTemp, maxTemp: $maxTemp, condition: $condition, iconCode: $iconCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForecastDtoImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.minTemp, minTemp) || other.minTemp == minTemp) &&
            (identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.iconCode, iconCode) ||
                other.iconCode == iconCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, minTemp, maxTemp, condition, iconCode);

  /// Create a copy of ForecastDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForecastDtoImplCopyWith<_$ForecastDtoImpl> get copyWith =>
      __$$ForecastDtoImplCopyWithImpl<_$ForecastDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForecastDtoImplToJson(this);
  }
}

abstract class _ForecastDto implements ForecastDto {
  const factory _ForecastDto({
    required final DateTime date,
    @JsonKey(name: 'min_temp') required final double minTemp,
    @JsonKey(name: 'max_temp') required final double maxTemp,
    required final String condition,
    @JsonKey(name: 'icon_code') required final String iconCode,
  }) = _$ForecastDtoImpl;

  factory _ForecastDto.fromJson(Map<String, dynamic> json) =
      _$ForecastDtoImpl.fromJson;

  @override
  DateTime get date;
  @override
  @JsonKey(name: 'min_temp')
  double get minTemp;
  @override
  @JsonKey(name: 'max_temp')
  double get maxTemp;
  @override
  String get condition;
  @override
  @JsonKey(name: 'icon_code')
  String get iconCode;

  /// Create a copy of ForecastDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForecastDtoImplCopyWith<_$ForecastDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
