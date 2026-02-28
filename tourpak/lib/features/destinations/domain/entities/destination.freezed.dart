// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Destination {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get heroImageUrl => throw _privateConstructorUsedError;
  String? get videoLoopUrl => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  List<String> get bestMonths => throw _privateConstructorUsedError;
  String? get roadStatus => throw _privateConstructorUsedError;
  String? get roadStatusNote => throw _privateConstructorUsedError;
  DateTime? get roadUpdatedAt => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Destination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DestinationCopyWith<Destination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DestinationCopyWith<$Res> {
  factory $DestinationCopyWith(
    Destination value,
    $Res Function(Destination) then,
  ) = _$DestinationCopyWithImpl<$Res, Destination>;
  @useResult
  $Res call({
    String id,
    String name,
    String? province,
    String? description,
    String? heroImageUrl,
    String? videoLoopUrl,
    double? latitude,
    double? longitude,
    List<String> bestMonths,
    String? roadStatus,
    String? roadStatusNote,
    DateTime? roadUpdatedAt,
    bool isFeatured,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$DestinationCopyWithImpl<$Res, $Val extends Destination>
    implements $DestinationCopyWith<$Res> {
  _$DestinationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Destination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? province = freezed,
    Object? description = freezed,
    Object? heroImageUrl = freezed,
    Object? videoLoopUrl = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? bestMonths = null,
    Object? roadStatus = freezed,
    Object? roadStatusNote = freezed,
    Object? roadUpdatedAt = freezed,
    Object? isFeatured = null,
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
            province: freezed == province
                ? _value.province
                : province // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            heroImageUrl: freezed == heroImageUrl
                ? _value.heroImageUrl
                : heroImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            videoLoopUrl: freezed == videoLoopUrl
                ? _value.videoLoopUrl
                : videoLoopUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            bestMonths: null == bestMonths
                ? _value.bestMonths
                : bestMonths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            roadStatus: freezed == roadStatus
                ? _value.roadStatus
                : roadStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            roadStatusNote: freezed == roadStatusNote
                ? _value.roadStatusNote
                : roadStatusNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            roadUpdatedAt: freezed == roadUpdatedAt
                ? _value.roadUpdatedAt
                : roadUpdatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isFeatured: null == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$DestinationImplCopyWith<$Res>
    implements $DestinationCopyWith<$Res> {
  factory _$$DestinationImplCopyWith(
    _$DestinationImpl value,
    $Res Function(_$DestinationImpl) then,
  ) = __$$DestinationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? province,
    String? description,
    String? heroImageUrl,
    String? videoLoopUrl,
    double? latitude,
    double? longitude,
    List<String> bestMonths,
    String? roadStatus,
    String? roadStatusNote,
    DateTime? roadUpdatedAt,
    bool isFeatured,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$DestinationImplCopyWithImpl<$Res>
    extends _$DestinationCopyWithImpl<$Res, _$DestinationImpl>
    implements _$$DestinationImplCopyWith<$Res> {
  __$$DestinationImplCopyWithImpl(
    _$DestinationImpl _value,
    $Res Function(_$DestinationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Destination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? province = freezed,
    Object? description = freezed,
    Object? heroImageUrl = freezed,
    Object? videoLoopUrl = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? bestMonths = null,
    Object? roadStatus = freezed,
    Object? roadStatusNote = freezed,
    Object? roadUpdatedAt = freezed,
    Object? isFeatured = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$DestinationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        province: freezed == province
            ? _value.province
            : province // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        heroImageUrl: freezed == heroImageUrl
            ? _value.heroImageUrl
            : heroImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        videoLoopUrl: freezed == videoLoopUrl
            ? _value.videoLoopUrl
            : videoLoopUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        bestMonths: null == bestMonths
            ? _value._bestMonths
            : bestMonths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        roadStatus: freezed == roadStatus
            ? _value.roadStatus
            : roadStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        roadStatusNote: freezed == roadStatusNote
            ? _value.roadStatusNote
            : roadStatusNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        roadUpdatedAt: freezed == roadUpdatedAt
            ? _value.roadUpdatedAt
            : roadUpdatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isFeatured: null == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$DestinationImpl extends _Destination {
  const _$DestinationImpl({
    required this.id,
    required this.name,
    this.province,
    this.description,
    this.heroImageUrl,
    this.videoLoopUrl,
    this.latitude,
    this.longitude,
    final List<String> bestMonths = const [],
    this.roadStatus,
    this.roadStatusNote,
    this.roadUpdatedAt,
    this.isFeatured = false,
    this.createdAt,
  }) : _bestMonths = bestMonths,
       super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String? province;
  @override
  final String? description;
  @override
  final String? heroImageUrl;
  @override
  final String? videoLoopUrl;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<String> _bestMonths;
  @override
  @JsonKey()
  List<String> get bestMonths {
    if (_bestMonths is EqualUnmodifiableListView) return _bestMonths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bestMonths);
  }

  @override
  final String? roadStatus;
  @override
  final String? roadStatusNote;
  @override
  final DateTime? roadUpdatedAt;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Destination(id: $id, name: $name, province: $province, description: $description, heroImageUrl: $heroImageUrl, videoLoopUrl: $videoLoopUrl, latitude: $latitude, longitude: $longitude, bestMonths: $bestMonths, roadStatus: $roadStatus, roadStatusNote: $roadStatusNote, roadUpdatedAt: $roadUpdatedAt, isFeatured: $isFeatured, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DestinationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.heroImageUrl, heroImageUrl) ||
                other.heroImageUrl == heroImageUrl) &&
            (identical(other.videoLoopUrl, videoLoopUrl) ||
                other.videoLoopUrl == videoLoopUrl) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(
              other._bestMonths,
              _bestMonths,
            ) &&
            (identical(other.roadStatus, roadStatus) ||
                other.roadStatus == roadStatus) &&
            (identical(other.roadStatusNote, roadStatusNote) ||
                other.roadStatusNote == roadStatusNote) &&
            (identical(other.roadUpdatedAt, roadUpdatedAt) ||
                other.roadUpdatedAt == roadUpdatedAt) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    province,
    description,
    heroImageUrl,
    videoLoopUrl,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_bestMonths),
    roadStatus,
    roadStatusNote,
    roadUpdatedAt,
    isFeatured,
    createdAt,
  );

  /// Create a copy of Destination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DestinationImplCopyWith<_$DestinationImpl> get copyWith =>
      __$$DestinationImplCopyWithImpl<_$DestinationImpl>(this, _$identity);
}

abstract class _Destination extends Destination {
  const factory _Destination({
    required final String id,
    required final String name,
    final String? province,
    final String? description,
    final String? heroImageUrl,
    final String? videoLoopUrl,
    final double? latitude,
    final double? longitude,
    final List<String> bestMonths,
    final String? roadStatus,
    final String? roadStatusNote,
    final DateTime? roadUpdatedAt,
    final bool isFeatured,
    final DateTime? createdAt,
  }) = _$DestinationImpl;
  const _Destination._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String? get province;
  @override
  String? get description;
  @override
  String? get heroImageUrl;
  @override
  String? get videoLoopUrl;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  List<String> get bestMonths;
  @override
  String? get roadStatus;
  @override
  String? get roadStatusNote;
  @override
  DateTime? get roadUpdatedAt;
  @override
  bool get isFeatured;
  @override
  DateTime? get createdAt;

  /// Create a copy of Destination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DestinationImplCopyWith<_$DestinationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
