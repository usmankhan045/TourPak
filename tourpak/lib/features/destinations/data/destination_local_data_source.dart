import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tourpak/core/constants/app_constants.dart';
import 'package:tourpak/features/destinations/data/dtos/destination_dto.dart';

/// Hive-backed local cache for destinations.
///
/// Stores the raw JSON list and a timestamp.
/// Cache expires after [AppConstants.cacheDuration] (1 hour).
class DestinationLocalDataSource {
  static const _cacheKey = 'destinations_list';
  static const _timestampKey = 'destinations_timestamp';

  Box get _box => Hive.box(AppConstants.cacheBox);

  /// Returns cached destinations, or `null` if the cache is empty.
  Future<List<DestinationDto>?> getCachedDestinations() async {
    final raw = _box.get(_cacheKey);
    if (raw == null) return null;

    final List<dynamic> decoded = jsonDecode(raw as String);
    return decoded
        .map((e) => DestinationDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Writes destinations to the local cache and records the timestamp.
  Future<void> cacheDestinations(List<DestinationDto> destinations) async {
    final json = jsonEncode(destinations.map((d) => d.toJson()).toList());
    await _box.put(_cacheKey, json);
    await _box.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// `true` when the cache is older than [AppConstants.cacheDuration] or empty.
  bool get isCacheStale {
    final timestamp = _box.get(_timestampKey) as int?;
    if (timestamp == null) return true;
    final cached = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cached) > AppConstants.cacheDuration;
  }

  /// Removes all cached destination data.
  Future<void> clearCache() async {
    await _box.delete(_cacheKey);
    await _box.delete(_timestampKey);
  }
}
