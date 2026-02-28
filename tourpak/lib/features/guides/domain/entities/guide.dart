import 'package:freezed_annotation/freezed_annotation.dart';

part 'guide.freezed.dart';

@freezed
class Guide with _$Guide {
  const Guide._();

  const factory Guide({
    required String id,
    required String name,
    String? destinationId,
    String? photoUrl,
    String? bio,
    String? phone,
    @Default(false) bool isVerified,
    double? rating,
    int? reviewCount,
    @Default([]) List<String> languages,
    @Default([]) List<String> specialties,
    double? dailyRate,
    int? yearsExperience,
    DateTime? createdAt,
  }) = _Guide;

  /// Formatted daily rate string.
  String get formattedRate =>
      dailyRate != null ? 'Rs.${dailyRate!.toInt().toStringAsFixed(0)}' : 'N/A';

  /// Formatted experience string.
  String get formattedExperience =>
      yearsExperience != null ? '$yearsExperience yrs exp' : 'N/A';
}
