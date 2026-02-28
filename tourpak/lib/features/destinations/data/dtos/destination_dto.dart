import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';

part 'destination_dto.freezed.dart';
part 'destination_dto.g.dart';

@freezed
class DestinationDto with _$DestinationDto {
  const DestinationDto._();

  const factory DestinationDto({
    required String id,
    required String name,
    String? province,
    String? description,
    @JsonKey(name: 'hero_image_url') String? heroImageUrl,
    @JsonKey(name: 'video_loop_url') String? videoLoopUrl,
    double? latitude,
    double? longitude,
    @Default([]) @JsonKey(name: 'best_months') List<String> bestMonths,
    @JsonKey(name: 'road_status') String? roadStatus,
    @JsonKey(name: 'road_status_note') String? roadStatusNote,
    @JsonKey(name: 'road_updated_at') DateTime? roadUpdatedAt,
    @Default(false) @JsonKey(name: 'is_featured') bool isFeatured,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _DestinationDto;

  /// Converts this DTO to a domain [Destination] entity.
  Destination toEntity() => Destination(
        id: id,
        name: name,
        province: province,
        description: description,
        heroImageUrl: heroImageUrl,
        videoLoopUrl: videoLoopUrl,
        latitude: latitude,
        longitude: longitude,
        bestMonths: bestMonths,
        roadStatus: roadStatus,
        roadStatusNote: roadStatusNote,
        roadUpdatedAt: roadUpdatedAt,
        isFeatured: isFeatured,
        createdAt: createdAt,
      );

  factory DestinationDto.fromJson(Map<String, dynamic> json) =>
      _$DestinationDtoFromJson(json);
}
