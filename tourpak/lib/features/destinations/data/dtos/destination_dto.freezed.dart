// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DestinationDto _$DestinationDtoFromJson(Map<String, dynamic> json) {
  return _DestinationDto.fromJson(json);
}

/// @nodoc
mixin _$DestinationDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'hero_image_url')
  String? get heroImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_loop_url')
  String? get videoLoopUrl => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_months')
  List<String> get bestMonths => throw _privateConstructorUsedError;
  @JsonKey(name: 'road_status')
  String? get roadStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'road_status_note')
  String? get roadStatusNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'road_updated_at')
  DateTime? get roadUpdatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DestinationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DestinationDtoCopyWith<DestinationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DestinationDtoCopyWith<$Res> {
  factory $DestinationDtoCopyWith(
    DestinationDto value,
    $Res Function(DestinationDto) then,
  ) = _$DestinationDtoCopyWithImpl<$Res, DestinationDto>;
  @useResult
  $Res call({
    String id,
    String name,
    String? province,
    String? description,
    @JsonKey(name: 'hero_image_url') String? heroImageUrl,
    @JsonKey(name: 'video_loop_url') String? videoLoopUrl,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'best_months') List<String> bestMonths,
    @JsonKey(name: 'road_status') String? roadStatus,
    @JsonKey(name: 'road_status_note') String? roadStatusNote,
    @JsonKey(name: 'road_updated_at') DateTime? roadUpdatedAt,
    @JsonKey(name: 'is_featured') bool isFeatured,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$DestinationDtoCopyWithImpl<$Res, $Val extends DestinationDto>
    implements $DestinationDtoCopyWith<$Res> {
  _$DestinationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DestinationDto
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
abstract class _$$DestinationDtoImplCopyWith<$Res>
    implements $DestinationDtoCopyWith<$Res> {
  factory _$$DestinationDtoImplCopyWith(
    _$DestinationDtoImpl value,
    $Res Function(_$DestinationDtoImpl) then,
  ) = __$$DestinationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? province,
    String? description,
    @JsonKey(name: 'hero_image_url') String? heroImageUrl,
    @JsonKey(name: 'video_loop_url') String? videoLoopUrl,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'best_months') List<String> bestMonths,
    @JsonKey(name: 'road_status') String? roadStatus,
    @JsonKey(name: 'road_status_note') String? roadStatusNote,
    @JsonKey(name: 'road_updated_at') DateTime? roadUpdatedAt,
    @JsonKey(name: 'is_featured') bool isFeatured,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$DestinationDtoImplCopyWithImpl<$Res>
    extends _$DestinationDtoCopyWithImpl<$Res, _$DestinationDtoImpl>
    implements _$$DestinationDtoImplCopyWith<$Res> {
  __$$DestinationDtoImplCopyWithImpl(
    _$DestinationDtoImpl _value,
    $Res Function(_$DestinationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DestinationDto
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
      _$DestinationDtoImpl(
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
@JsonSerializable()
class _$DestinationDtoImpl extends _DestinationDto {
  const _$DestinationDtoImpl({
    required this.id,
    required this.name,
    this.province,
    this.description,
    @JsonKey(name: 'hero_image_url') this.heroImageUrl,
    @JsonKey(name: 'video_loop_url') this.videoLoopUrl,
    this.latitude,
    this.longitude,
    @JsonKey(name: 'best_months') final List<String> bestMonths = const [],
    @JsonKey(name: 'road_status') this.roadStatus,
    @JsonKey(name: 'road_status_note') this.roadStatusNote,
    @JsonKey(name: 'road_updated_at') this.roadUpdatedAt,
    @JsonKey(name: 'is_featured') this.isFeatured = false,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _bestMonths = bestMonths,
       super._();

  factory _$DestinationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DestinationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? province;
  @override
  final String? description;
  @override
  @JsonKey(name: 'hero_image_url')
  final String? heroImageUrl;
  @override
  @JsonKey(name: 'video_loop_url')
  final String? videoLoopUrl;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<String> _bestMonths;
  @override
  @JsonKey(name: 'best_months')
  List<String> get bestMonths {
    if (_bestMonths is EqualUnmodifiableListView) return _bestMonths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bestMonths);
  }

  @override
  @JsonKey(name: 'road_status')
  final String? roadStatus;
  @override
  @JsonKey(name: 'road_status_note')
  final String? roadStatusNote;
  @override
  @JsonKey(name: 'road_updated_at')
  final DateTime? roadUpdatedAt;
  @override
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'DestinationDto(id: $id, name: $name, province: $province, description: $description, heroImageUrl: $heroImageUrl, videoLoopUrl: $videoLoopUrl, latitude: $latitude, longitude: $longitude, bestMonths: $bestMonths, roadStatus: $roadStatus, roadStatusNote: $roadStatusNote, roadUpdatedAt: $roadUpdatedAt, isFeatured: $isFeatured, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DestinationDtoImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of DestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DestinationDtoImplCopyWith<_$DestinationDtoImpl> get copyWith =>
      __$$DestinationDtoImplCopyWithImpl<_$DestinationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DestinationDtoImplToJson(this);
  }
}

abstract class _DestinationDto extends DestinationDto {
  const factory _DestinationDto({
    required final String id,
    required final String name,
    final String? province,
    final String? description,
    @JsonKey(name: 'hero_image_url') final String? heroImageUrl,
    @JsonKey(name: 'video_loop_url') final String? videoLoopUrl,
    final double? latitude,
    final double? longitude,
    @JsonKey(name: 'best_months') final List<String> bestMonths,
    @JsonKey(name: 'road_status') final String? roadStatus,
    @JsonKey(name: 'road_status_note') final String? roadStatusNote,
    @JsonKey(name: 'road_updated_at') final DateTime? roadUpdatedAt,
    @JsonKey(name: 'is_featured') final bool isFeatured,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$DestinationDtoImpl;
  const _DestinationDto._() : super._();

  factory _DestinationDto.fromJson(Map<String, dynamic> json) =
      _$DestinationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get province;
  @override
  String? get description;
  @override
  @JsonKey(name: 'hero_image_url')
  String? get heroImageUrl;
  @override
  @JsonKey(name: 'video_loop_url')
  String? get videoLoopUrl;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'best_months')
  List<String> get bestMonths;
  @override
  @JsonKey(name: 'road_status')
  String? get roadStatus;
  @override
  @JsonKey(name: 'road_status_note')
  String? get roadStatusNote;
  @override
  @JsonKey(name: 'road_updated_at')
  DateTime? get roadUpdatedAt;
  @override
  @JsonKey(name: 'is_featured')
  bool get isFeatured;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of DestinationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DestinationDtoImplCopyWith<_$DestinationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
