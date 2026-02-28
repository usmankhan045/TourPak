/// App-wide constants for TourPak
class AppConstants {
  AppConstants._();

  static const String appName = 'TourPak';
  static const String appTagline = 'Explore Pakistan Like Never Before';

  // API
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration cacheDuration = Duration(hours: 1);

  // Map defaults (centered on Pakistan)
  static const double defaultLatitude = 30.3753;
  static const double defaultLongitude = 69.3451;
  static const double defaultZoom = 5.5;

  // Hive box names
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
  static const String favoritesBox = 'favorites';
}
