// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DestinationDtoImpl _$$DestinationDtoImplFromJson(Map<String, dynamic> json) =>
    _$DestinationDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      province: json['province'] as String?,
      description: json['description'] as String?,
      heroImageUrl: json['hero_image_url'] as String?,
      videoLoopUrl: json['video_loop_url'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      bestMonths:
          (json['best_months'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      roadStatus: json['road_status'] as String?,
      roadStatusNote: json['road_status_note'] as String?,
      roadUpdatedAt: json['road_updated_at'] == null
          ? null
          : DateTime.parse(json['road_updated_at'] as String),
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$DestinationDtoImplToJson(
  _$DestinationDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'province': instance.province,
  'description': instance.description,
  'hero_image_url': instance.heroImageUrl,
  'video_loop_url': instance.videoLoopUrl,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'best_months': instance.bestMonths,
  'road_status': instance.roadStatus,
  'road_status_note': instance.roadStatusNote,
  'road_updated_at': instance.roadUpdatedAt?.toIso8601String(),
  'is_featured': instance.isFeatured,
  'created_at': instance.createdAt?.toIso8601String(),
};
