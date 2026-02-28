import 'dart:convert';

import 'package:hive/hive.dart';

/// Generic, TTL-aware cache manager backed by a Hive box.
///
/// Data is stored as JSON strings. Each entry keeps a `data` payload
/// alongside a `cachedAt` timestamp so [isValid] can enforce expiry.
///
/// Usage:
/// ```dart
/// final cache = HiveCacheManager<List<Map<String, dynamic>>>(
///   boxName: 'destinations_cache',
///   ttl: Duration(hours: 1),
/// );
/// await cache.put('all', dtoListJson);
/// final cached = await cache.get('all');
/// ```
class HiveCacheManager<T> {
  final String boxName;
  final Duration ttl;

  HiveCacheManager({required this.boxName, required this.ttl});

  Future<Box> _openBox() => Hive.openBox(boxName);

  /// Stores [value] under [key] as a JSON-encoded string.
  ///
  /// The value is wrapped in an envelope that also records the current
  /// timestamp so [isValid] can enforce the TTL.
  Future<void> put(String key, T value) async {
    final box = await _openBox();
    final envelope = {
      'data': jsonEncode(value),
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    };
    await box.put(key, jsonEncode(envelope));
  }

  /// Returns the cached value for [key], or `null` if absent.
  ///
  /// **Does not** enforce TTL — callers should check [isValid] first
  /// if they need freshness guarantees.
  Future<T?> get(String key) async {
    final box = await _openBox();
    final raw = box.get(key);
    if (raw == null) return null;

    final envelope = jsonDecode(raw as String) as Map<String, dynamic>;
    final data = jsonDecode(envelope['data'] as String);
    return data as T;
  }

  /// Returns `true` when [key] exists **and** is within the [ttl] window.
  Future<bool> isValid(String key) async {
    final box = await _openBox();
    final raw = box.get(key);
    if (raw == null) return false;

    final envelope = jsonDecode(raw as String) as Map<String, dynamic>;
    final cachedAt = envelope['cachedAt'] as int;
    final elapsed = DateTime.now().millisecondsSinceEpoch - cachedAt;
    return elapsed < ttl.inMilliseconds;
  }

  /// Removes all entries from this cache box.
  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }

  /// Removes a single [key] from the cache.
  Future<void> delete(String key) async {
    final box = await _openBox();
    await box.delete(key);
  }
}
