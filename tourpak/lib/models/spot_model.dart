class SpotModel {
  final String id;
  final String destinationId;
  final String name;
  final String category;
  final String description;
  final String coverImageUrl;
  final double latitude;
  final double longitude;
  final double distanceFromCity;
  final double elevation;
  final String bestTimeToVisit;
  final List<String> activities;
  final bool isFeatured;

  const SpotModel({
    required this.id,
    required this.destinationId,
    required this.name,
    required this.category,
    required this.description,
    required this.coverImageUrl,
    required this.latitude,
    required this.longitude,
    required this.distanceFromCity,
    required this.elevation,
    required this.bestTimeToVisit,
    required this.activities,
    this.isFeatured = false,
  });
}
