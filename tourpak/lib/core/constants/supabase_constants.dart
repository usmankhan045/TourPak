import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration for TourPak
///
/// Credentials loaded from .env file at runtime.
class SupabaseConstants {
  SupabaseConstants._();

  static String get supabaseUrl => dotenv.env['SUPABASE_URL']!;
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY']!;

  // Table names
  static const String destinationsTable = 'destinations';
  static const String touristSpotsTable = 'tourist_spots';
  static const String restaurantsTable = 'restaurants';
  static const String guidesTable = 'guides';
  static const String emergencyContactsTable = 'emergency_contacts';

  // Storage buckets
  static const String destinationImagesBucket = 'destination-images';
  static const String spotImagesBucket = 'spot-images';
  static const String guidePhotosBucket = 'guide-photos';
  static const String profilePhotosBucket = 'profile-photos';
}
