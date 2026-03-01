class GuideModel {
  final String id;
  final String destinationId;
  final String name;
  final String photoUrl;
  final List<String> languages;
  final String speciality;
  final int pricePerDay;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final int yearsExperience;
  final String about;
  final String phone;
  final String whatsapp;

  const GuideModel({
    required this.id,
    required this.destinationId,
    required this.name,
    required this.photoUrl,
    required this.languages,
    required this.speciality,
    required this.pricePerDay,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.yearsExperience,
    required this.about,
    required this.phone,
    required this.whatsapp,
  });
}
