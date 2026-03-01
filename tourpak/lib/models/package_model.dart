class PackageModel {
  final String id;
  final String destinationId;
  final String title;
  final String operatorName;
  final bool operatorVerified;
  final String coverImageUrl;
  final int durationDays;
  final int durationNights;
  final String startingCity;
  final int pricePerPerson;
  final String packageType;
  final List<String> inclusions;
  final List<String> exclusions;
  final String pickupPoint;
  final List<String> itinerary;
  final double rating;
  final int maxGroupSize;

  const PackageModel({
    required this.id,
    required this.destinationId,
    required this.title,
    required this.operatorName,
    required this.operatorVerified,
    required this.coverImageUrl,
    required this.durationDays,
    required this.durationNights,
    required this.startingCity,
    required this.pricePerPerson,
    required this.packageType,
    required this.inclusions,
    required this.exclusions,
    required this.pickupPoint,
    required this.itinerary,
    required this.rating,
    required this.maxGroupSize,
  });
}
