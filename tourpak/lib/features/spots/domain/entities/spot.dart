import 'package:freezed_annotation/freezed_annotation.dart';

part 'spot.freezed.dart';

@freezed
class Spot with _$Spot {
  const Spot._();

  const factory Spot({
    required String id,
    required String name,
    required String destinationId,
    String? category,
    String? heroImageUrl,
    @Default([]) List<String> galleryUrls,
    String? description,
    String? bestTime,
    double? altitude,
    String? entryFee,
    String? hours,
    double? latitude,
    double? longitude,
    @Default(0) int nearbyHotels,
    @Default(0) int nearbyPharmacies,
    @Default(0) int nearbyHospitals,
    @Default(0) int nearbyRestaurants,
    DateTime? createdAt,
  }) = _Spot;

  /// Whether the spot has GPS coordinates for map display.
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Total gallery count including the hero image.
  int get totalPhotos =>
      galleryUrls.length + (heroImageUrl != null ? 1 : 0);
}
