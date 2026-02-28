// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Spot {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get destinationId => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get heroImageUrl => throw _privateConstructorUsedError;
  List<String> get galleryUrls => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get bestTime => throw _privateConstructorUsedError;
  double? get altitude => throw _privateConstructorUsedError;
  String? get entryFee => throw _privateConstructorUsedError;
  String? get hours => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  int get nearbyHotels => throw _privateConstructorUsedError;
  int get nearbyPharmacies => throw _privateConstructorUsedError;
  int get nearbyHospitals => throw _privateConstructorUsedError;
  int get nearbyRestaurants => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotCopyWith<Spot> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotCopyWith<$Res> {
  factory $SpotCopyWith(Spot value, $Res Function(Spot) then) =
      _$SpotCopyWithImpl<$Res, Spot>;
  @useResult
  $Res call({
    String id,
    String name,
    String destinationId,
    String? category,
    String? heroImageUrl,
    List<String> galleryUrls,
    String? description,
    String? bestTime,
    double? altitude,
    String? entryFee,
    String? hours,
    double? latitude,
    double? longitude,
    int nearbyHotels,
    int nearbyPharmacies,
    int nearbyHospitals,
    int nearbyRestaurants,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$SpotCopyWithImpl<$Res, $Val extends Spot>
    implements $SpotCopyWith<$Res> {
  _$SpotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destinationId = null,
    Object? category = freezed,
    Object? heroImageUrl = freezed,
    Object? galleryUrls = null,
    Object? description = freezed,
    Object? bestTime = freezed,
    Object? altitude = freezed,
    Object? entryFee = freezed,
    Object? hours = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? nearbyHotels = null,
    Object? nearbyPharmacies = null,
    Object? nearbyHospitals = null,
    Object? nearbyRestaurants = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            destinationId: null == destinationId
                ? _value.destinationId
                : destinationId // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            heroImageUrl: freezed == heroImageUrl
                ? _value.heroImageUrl
                : heroImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            galleryUrls: null == galleryUrls
                ? _value.galleryUrls
                : galleryUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            bestTime: freezed == bestTime
                ? _value.bestTime
                : bestTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            altitude: freezed == altitude
                ? _value.altitude
                : altitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            entryFee: freezed == entryFee
                ? _value.entryFee
                : entryFee // ignore: cast_nullable_to_non_nullable
                      as String?,
            hours: freezed == hours
                ? _value.hours
                : hours // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            nearbyHotels: null == nearbyHotels
                ? _value.nearbyHotels
                : nearbyHotels // ignore: cast_nullable_to_non_nullable
                      as int,
            nearbyPharmacies: null == nearbyPharmacies
                ? _value.nearbyPharmacies
                : nearbyPharmacies // ignore: cast_nullable_to_non_nullable
                      as int,
            nearbyHospitals: null == nearbyHospitals
                ? _value.nearbyHospitals
                : nearbyHospitals // ignore: cast_nullable_to_non_nullable
                      as int,
            nearbyRestaurants: null == nearbyRestaurants
                ? _value.nearbyRestaurants
                : nearbyRestaurants // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpotImplCopyWith<$Res> implements $SpotCopyWith<$Res> {
  factory _$$SpotImplCopyWith(
    _$SpotImpl value,
    $Res Function(_$SpotImpl) then,
  ) = __$$SpotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String destinationId,
    String? category,
    String? heroImageUrl,
    List<String> galleryUrls,
    String? description,
    String? bestTime,
    double? altitude,
    String? entryFee,
    String? hours,
    double? latitude,
    double? longitude,
    int nearbyHotels,
    int nearbyPharmacies,
    int nearbyHospitals,
    int nearbyRestaurants,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$SpotImplCopyWithImpl<$Res>
    extends _$SpotCopyWithImpl<$Res, _$SpotImpl>
    implements _$$SpotImplCopyWith<$Res> {
  __$$SpotImplCopyWithImpl(_$SpotImpl _value, $Res Function(_$SpotImpl) _then)
    : super(_value, _then);

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destinationId = null,
    Object? category = freezed,
    Object? heroImageUrl = freezed,
    Object? galleryUrls = null,
    Object? description = freezed,
    Object? bestTime = freezed,
    Object? altitude = freezed,
    Object? entryFee = freezed,
    Object? hours = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? nearbyHotels = null,
    Object? nearbyPharmacies = null,
    Object? nearbyHospitals = null,
    Object? nearbyRestaurants = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SpotImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        destinationId: null == destinationId
            ? _value.destinationId
            : destinationId // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        heroImageUrl: freezed == heroImageUrl
            ? _value.heroImageUrl
            : heroImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        galleryUrls: null == galleryUrls
            ? _value._galleryUrls
            : galleryUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        bestTime: freezed == bestTime
            ? _value.bestTime
            : bestTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        altitude: freezed == altitude
            ? _value.altitude
            : altitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        entryFee: freezed == entryFee
            ? _value.entryFee
            : entryFee // ignore: cast_nullable_to_non_nullable
                  as String?,
        hours: freezed == hours
            ? _value.hours
            : hours // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        nearbyHotels: null == nearbyHotels
            ? _value.nearbyHotels
            : nearbyHotels // ignore: cast_nullable_to_non_nullable
                  as int,
        nearbyPharmacies: null == nearbyPharmacies
            ? _value.nearbyPharmacies
            : nearbyPharmacies // ignore: cast_nullable_to_non_nullable
                  as int,
        nearbyHospitals: null == nearbyHospitals
            ? _value.nearbyHospitals
            : nearbyHospitals // ignore: cast_nullable_to_non_nullable
                  as int,
        nearbyRestaurants: null == nearbyRestaurants
            ? _value.nearbyRestaurants
            : nearbyRestaurants // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$SpotImpl extends _Spot {
  const _$SpotImpl({
    required this.id,
    required this.name,
    required this.destinationId,
    this.category,
    this.heroImageUrl,
    final List<String> galleryUrls = const [],
    this.description,
    this.bestTime,
    this.altitude,
    this.entryFee,
    this.hours,
    this.latitude,
    this.longitude,
    this.nearbyHotels = 0,
    this.nearbyPharmacies = 0,
    this.nearbyHospitals = 0,
    this.nearbyRestaurants = 0,
    this.createdAt,
  }) : _galleryUrls = galleryUrls,
       super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String destinationId;
  @override
  final String? category;
  @override
  final String? heroImageUrl;
  final List<String> _galleryUrls;
  @override
  @JsonKey()
  List<String> get galleryUrls {
    if (_galleryUrls is EqualUnmodifiableListView) return _galleryUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryUrls);
  }

  @override
  final String? description;
  @override
  final String? bestTime;
  @override
  final double? altitude;
  @override
  final String? entryFee;
  @override
  final String? hours;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey()
  final int nearbyHotels;
  @override
  @JsonKey()
  final int nearbyPharmacies;
  @override
  @JsonKey()
  final int nearbyHospitals;
  @override
  @JsonKey()
  final int nearbyRestaurants;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Spot(id: $id, name: $name, destinationId: $destinationId, category: $category, heroImageUrl: $heroImageUrl, galleryUrls: $galleryUrls, description: $description, bestTime: $bestTime, altitude: $altitude, entryFee: $entryFee, hours: $hours, latitude: $latitude, longitude: $longitude, nearbyHotels: $nearbyHotels, nearbyPharmacies: $nearbyPharmacies, nearbyHospitals: $nearbyHospitals, nearbyRestaurants: $nearbyRestaurants, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.destinationId, destinationId) ||
                other.destinationId == destinationId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.heroImageUrl, heroImageUrl) ||
                other.heroImageUrl == heroImageUrl) &&
            const DeepCollectionEquality().equals(
              other._galleryUrls,
              _galleryUrls,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bestTime, bestTime) ||
                other.bestTime == bestTime) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.entryFee, entryFee) ||
                other.entryFee == entryFee) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.nearbyHotels, nearbyHotels) ||
                other.nearbyHotels == nearbyHotels) &&
            (identical(other.nearbyPharmacies, nearbyPharmacies) ||
                other.nearbyPharmacies == nearbyPharmacies) &&
            (identical(other.nearbyHospitals, nearbyHospitals) ||
                other.nearbyHospitals == nearbyHospitals) &&
            (identical(other.nearbyRestaurants, nearbyRestaurants) ||
                other.nearbyRestaurants == nearbyRestaurants) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    destinationId,
    category,
    heroImageUrl,
    const DeepCollectionEquality().hash(_galleryUrls),
    description,
    bestTime,
    altitude,
    entryFee,
    hours,
    latitude,
    longitude,
    nearbyHotels,
    nearbyPharmacies,
    nearbyHospitals,
    nearbyRestaurants,
    createdAt,
  );

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotImplCopyWith<_$SpotImpl> get copyWith =>
      __$$SpotImplCopyWithImpl<_$SpotImpl>(this, _$identity);
}

abstract class _Spot extends Spot {
  const factory _Spot({
    required final String id,
    required final String name,
    required final String destinationId,
    final String? category,
    final String? heroImageUrl,
    final List<String> galleryUrls,
    final String? description,
    final String? bestTime,
    final double? altitude,
    final String? entryFee,
    final String? hours,
    final double? latitude,
    final double? longitude,
    final int nearbyHotels,
    final int nearbyPharmacies,
    final int nearbyHospitals,
    final int nearbyRestaurants,
    final DateTime? createdAt,
  }) = _$SpotImpl;
  const _Spot._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get destinationId;
  @override
  String? get category;
  @override
  String? get heroImageUrl;
  @override
  List<String> get galleryUrls;
  @override
  String? get description;
  @override
  String? get bestTime;
  @override
  double? get altitude;
  @override
  String? get entryFee;
  @override
  String? get hours;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  int get nearbyHotels;
  @override
  int get nearbyPharmacies;
  @override
  int get nearbyHospitals;
  @override
  int get nearbyRestaurants;
  @override
  DateTime? get createdAt;

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotImplCopyWith<_$SpotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
