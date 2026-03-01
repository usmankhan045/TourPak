import 'dart:io' show Platform;

import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/spots/domain/entities/spot.dart';

// ══════════════════════════════════════════════════════════════
// MAPS SERVICE — location, distance, navigation helpers
// ══════════════════════════════════════════════════════════════

class MapsService {
  MapsService._();

  // ── 1. Get current GPS position ──────────────────────────

  /// Returns the device's current position, or `null` if permission
  /// is denied, location services are off, or any error occurs.
  static Future<Position?> getCurrentLocation() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  // ── 2. Distance in metres between two coordinates ────────

  /// Returns the distance in metres between two lat/lng pairs.
  static double distanceBetween(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  // ── 3. Formatted distance string ─────────────────────────

  /// Converts a distance in metres to a human-readable string.
  static String formatDistance(double metres) {
    if (metres < 1000) return '${metres.round()} m away';
    return '${(metres / 1000).toStringAsFixed(1)} km away';
  }

  // ── 4. Open turn-by-turn navigation ──────────────────────

  /// Opens Google Maps (native app if installed, otherwise browser)
  /// with turn-by-turn driving directions to [destLat], [destLng].
  ///
  /// If [getCurrentLocation] succeeds the current position is set as
  /// the origin; otherwise Google Maps will ask the user for one.
  static Future<void> openDirections(
    double destLat,
    double destLng,
    String destName,
  ) async {
    final pos = await getCurrentLocation();

    // Build web fallback URL
    final StringBuffer webUrl = StringBuffer(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$destLat,$destLng'
      '&travelmode=driving',
    );
    if (pos != null) {
      webUrl.write('&origin=${pos.latitude},${pos.longitude}');
    }

    // Try native Google Maps app first
    final nativeScheme = Platform.isIOS
        ? 'comgooglemaps://?daddr=$destLat,$destLng&directionsmode=driving'
        : 'google.navigation:q=$destLat,$destLng&mode=d';

    final nativeUri = Uri.parse(nativeScheme);
    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri);
    } else {
      await launchUrl(
        Uri.parse(webUrl.toString()),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // ── 5. Open location in maps (view only) ─────────────────

  /// Opens [lat], [lng] in Google Maps for viewing (no directions).
  static Future<void> openInMaps(
    double lat,
    double lng,
    String label,
  ) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  // ── 6. Sort spots by distance ────────────────────────────

  /// Returns a copy of [spots] sorted by distance from
  /// [fromLat], [fromLng].  Spots without coordinates are
  /// placed at the end in their original order.
  static List<Spot> sortByDistance(
    List<Spot> spots,
    double fromLat,
    double fromLng,
  ) {
    final withCoords = spots.where((s) => s.hasCoordinates).toList();
    final withoutCoords = spots.where((s) => !s.hasCoordinates).toList();

    withCoords.sort((a, b) {
      final distA =
          distanceBetween(fromLat, fromLng, a.latitude!, a.longitude!);
      final distB =
          distanceBetween(fromLat, fromLng, b.latitude!, b.longitude!);
      return distA.compareTo(distB);
    });

    return [...withCoords, ...withoutCoords];
  }
}
