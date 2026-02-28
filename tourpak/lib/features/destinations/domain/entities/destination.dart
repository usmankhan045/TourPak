import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination.freezed.dart';

@freezed
class Destination with _$Destination {
  const Destination._();

  const factory Destination({
    required String id,
    required String name,
    String? province,
    String? description,
    String? heroImageUrl,
    String? videoLoopUrl,
    double? latitude,
    double? longitude,
    @Default([]) List<String> bestMonths,
    String? roadStatus,
    String? roadStatusNote,
    DateTime? roadUpdatedAt,
    @Default(false) bool isFeatured,
    DateTime? createdAt,
  }) = _Destination;

  /// True when the road status is yellow (caution) or red (closed).
  bool get hasRoadIssue => roadStatus != null && roadStatus != 'green';
}
