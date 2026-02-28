// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Weather {
  double get temp => throw _privateConstructorUsedError;
  double get feelsLike => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String get iconCode => throw _privateConstructorUsedError;
  int get humidity => throw _privateConstructorUsedError;
  double get windSpeed => throw _privateConstructorUsedError;

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherCopyWith<Weather> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherCopyWith<$Res> {
  factory $WeatherCopyWith(Weather value, $Res Function(Weather) then) =
      _$WeatherCopyWithImpl<$Res, Weather>;
  @useResult
  $Res call({
    double temp,
    double feelsLike,
    String condition,
    String iconCode,
    int humidity,
    double windSpeed,
  });
}

/// @nodoc
class _$WeatherCopyWithImpl<$Res, $Val extends Weather>
    implements $WeatherCopyWith<$Res> {
  _$WeatherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Weather
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
abstract class _$$WeatherImplCopyWith<$Res> implements $WeatherCopyWith<$Res> {
  factory _$$WeatherImplCopyWith(
    _$WeatherImpl value,
    $Res Function(_$WeatherImpl) then,
  ) = __$$WeatherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double temp,
    double feelsLike,
    String condition,
    String iconCode,
    int humidity,
    double windSpeed,
  });
}

/// @nodoc
class __$$WeatherImplCopyWithImpl<$Res>
    extends _$WeatherCopyWithImpl<$Res, _$WeatherImpl>
    implements _$$WeatherImplCopyWith<$Res> {
  __$$WeatherImplCopyWithImpl(
    _$WeatherImpl _value,
    $Res Function(_$WeatherImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Weather
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
      _$WeatherImpl(
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

class _$WeatherImpl implements _Weather {
  const _$WeatherImpl({
    required this.temp,
    required this.feelsLike,
    required this.condition,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  final double temp;
  @override
  final double feelsLike;
  @override
  final String condition;
  @override
  final String iconCode;
  @override
  final int humidity;
  @override
  final double windSpeed;

  @override
  String toString() {
    return 'Weather(temp: $temp, feelsLike: $feelsLike, condition: $condition, iconCode: $iconCode, humidity: $humidity, windSpeed: $windSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherImpl &&
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

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherImplCopyWith<_$WeatherImpl> get copyWith =>
      __$$WeatherImplCopyWithImpl<_$WeatherImpl>(this, _$identity);
}

abstract class _Weather implements Weather {
  const factory _Weather({
    required final double temp,
    required final double feelsLike,
    required final String condition,
    required final String iconCode,
    required final int humidity,
    required final double windSpeed,
  }) = _$WeatherImpl;

  @override
  double get temp;
  @override
  double get feelsLike;
  @override
  String get condition;
  @override
  String get iconCode;
  @override
  int get humidity;
  @override
  double get windSpeed;

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherImplCopyWith<_$WeatherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ForecastDay {
  DateTime get date => throw _privateConstructorUsedError;
  double get minTemp => throw _privateConstructorUsedError;
  double get maxTemp => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String get iconCode => throw _privateConstructorUsedError;

  /// Create a copy of ForecastDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForecastDayCopyWith<ForecastDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastDayCopyWith<$Res> {
  factory $ForecastDayCopyWith(
    ForecastDay value,
    $Res Function(ForecastDay) then,
  ) = _$ForecastDayCopyWithImpl<$Res, ForecastDay>;
  @useResult
  $Res call({
    DateTime date,
    double minTemp,
    double maxTemp,
    String condition,
    String iconCode,
  });
}

/// @nodoc
class _$ForecastDayCopyWithImpl<$Res, $Val extends ForecastDay>
    implements $ForecastDayCopyWith<$Res> {
  _$ForecastDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForecastDay
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
abstract class _$$ForecastDayImplCopyWith<$Res>
    implements $ForecastDayCopyWith<$Res> {
  factory _$$ForecastDayImplCopyWith(
    _$ForecastDayImpl value,
    $Res Function(_$ForecastDayImpl) then,
  ) = __$$ForecastDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    double minTemp,
    double maxTemp,
    String condition,
    String iconCode,
  });
}

/// @nodoc
class __$$ForecastDayImplCopyWithImpl<$Res>
    extends _$ForecastDayCopyWithImpl<$Res, _$ForecastDayImpl>
    implements _$$ForecastDayImplCopyWith<$Res> {
  __$$ForecastDayImplCopyWithImpl(
    _$ForecastDayImpl _value,
    $Res Function(_$ForecastDayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForecastDay
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
      _$ForecastDayImpl(
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

class _$ForecastDayImpl implements _ForecastDay {
  const _$ForecastDayImpl({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.iconCode,
  });

  @override
  final DateTime date;
  @override
  final double minTemp;
  @override
  final double maxTemp;
  @override
  final String condition;
  @override
  final String iconCode;

  @override
  String toString() {
    return 'ForecastDay(date: $date, minTemp: $minTemp, maxTemp: $maxTemp, condition: $condition, iconCode: $iconCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForecastDayImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.minTemp, minTemp) || other.minTemp == minTemp) &&
            (identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.iconCode, iconCode) ||
                other.iconCode == iconCode));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, minTemp, maxTemp, condition, iconCode);

  /// Create a copy of ForecastDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForecastDayImplCopyWith<_$ForecastDayImpl> get copyWith =>
      __$$ForecastDayImplCopyWithImpl<_$ForecastDayImpl>(this, _$identity);
}

abstract class _ForecastDay implements ForecastDay {
  const factory _ForecastDay({
    required final DateTime date,
    required final double minTemp,
    required final double maxTemp,
    required final String condition,
    required final String iconCode,
  }) = _$ForecastDayImpl;

  @override
  DateTime get date;
  @override
  double get minTemp;
  @override
  double get maxTemp;
  @override
  String get condition;
  @override
  String get iconCode;

  /// Create a copy of ForecastDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForecastDayImplCopyWith<_$ForecastDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
