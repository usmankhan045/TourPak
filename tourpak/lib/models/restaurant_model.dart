class RestaurantModel {
  final String id;
  final String destinationId;
  final String name;
  final String cuisineType;
  final String priceRange;
  final double rating;
  final int reviewCount;
  final String address;
  final String areaName;
  final String phone;
  final double latitude;
  final double longitude;
  final String coverImageUrl;
  final bool isSponsored;

  const RestaurantModel({
    required this.id,
    required this.destinationId,
    required this.name,
    required this.cuisineType,
    required this.priceRange,
    required this.rating,
    required this.reviewCount,
    required this.address,
    required this.areaName,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.coverImageUrl,
    this.isSponsored = false,
  });
}
