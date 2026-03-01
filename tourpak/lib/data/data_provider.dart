import 'package:geolocator/geolocator.dart';

import '../models/guide_model.dart';
import '../models/package_model.dart';
import '../models/restaurant_model.dart';
import '../models/spot_model.dart';
import 'swat_data.dart';

class DataProvider {
  static final DataProvider _instance = DataProvider._();
  factory DataProvider() => _instance;
  DataProvider._();

  // ── All data sets keyed by destination ──────────────────────

  final Map<String, List<SpotModel>> _spots = {
    'swat': swatSpots,
  };

  final Map<String, List<RestaurantModel>> _restaurants = {
    'swat': swatRestaurants,
  };

  final Map<String, List<GuideModel>> _guides = {
    'swat': swatGuides,
  };

  final Map<String, List<PackageModel>> _packages = {
    'swat': swatPackages,
  };

  // ── Spots ──────────────────────────────────────────────────

  List<SpotModel> getSpotsByDestination(String destId) {
    return _spots[destId] ?? [];
  }

  List<SpotModel> getFeaturedSpots(String destId) {
    return getSpotsByDestination(destId)
        .where((s) => s.isFeatured)
        .toList();
  }

  SpotModel? getSpotById(String id) {
    for (final list in _spots.values) {
      for (final spot in list) {
        if (spot.id == id) return spot;
      }
    }
    return null;
  }

  /// Returns the [count] nearest spots to the given [spotId],
  /// sorted by distance (nearest first).
  List<SpotModel> getNearbySpots(String spotId, {int count = 3}) {
    final target = getSpotById(spotId);
    if (target == null) return [];

    final siblings = getSpotsByDestination(target.destinationId)
        .where((s) => s.id != spotId)
        .toList();

    siblings.sort((a, b) {
      final da = Geolocator.distanceBetween(
        target.latitude,
        target.longitude,
        a.latitude,
        a.longitude,
      );
      final db = Geolocator.distanceBetween(
        target.latitude,
        target.longitude,
        b.latitude,
        b.longitude,
      );
      return da.compareTo(db);
    });

    return siblings.take(count).toList();
  }

  // ── Restaurants ────────────────────────────────────────────

  List<RestaurantModel> getRestaurantsByDestination(String destId) {
    return _restaurants[destId] ?? [];
  }

  // ── Guides ─────────────────────────────────────────────────

  List<GuideModel> getGuidesByDestination(String destId) {
    return _guides[destId] ?? [];
  }

  // ── Packages ───────────────────────────────────────────────

  List<PackageModel> getPackagesByDestination(String destId) {
    return _packages[destId] ?? [];
  }
}
