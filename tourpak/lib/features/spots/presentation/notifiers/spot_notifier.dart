import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourpak/core/constants/supabase_constants.dart';

import '../../domain/entities/spot.dart';

/// Parses a single tourist-spot JSON row into a [Spot] entity.
Spot _spotFromJson(Map<String, dynamic> j) {
  final months = (j['best_months'] as List<dynamic>?)?.cast<String>() ?? [];
  return Spot(
    id: j['id'] as String,
    name: j['name'] as String,
    destinationId: j['destination_id'] as String,
    category: j['category'] as String?,
    heroImageUrl: j['hero_image_url'] as String?,
    galleryUrls:
        (j['gallery_urls'] as List<dynamic>?)?.cast<String>() ?? [],
    description: j['description'] as String?,
    bestTime: months.isNotEmpty ? months.join(', ') : null,
    altitude: (j['altitude_meters'] as num?)?.toDouble(),
    entryFee: j['entry_fee'] as String?,
    hours: j['visiting_hours'] as String?,
    latitude: (j['latitude'] as num?)?.toDouble(),
    longitude: (j['longitude'] as num?)?.toDouble(),
  );
}

/// Fetches tourist spots for a given destination from Supabase.
final spotsByDestinationProvider =
    FutureProvider.family<List<Spot>, String>((ref, destinationId) async {
  final response = await Supabase.instance.client
      .from(SupabaseConstants.touristSpotsTable)
      .select()
      .eq('destination_id', destinationId);

  return (response as List)
      .map((e) => _spotFromJson(Map<String, dynamic>.from(e)))
      .toList();
});

/// Fetches featured tourist spots for a given destination from Supabase.
final featuredSpotsByDestinationProvider =
    FutureProvider.family<List<Spot>, String>((ref, destinationId) async {
  final response = await Supabase.instance.client
      .from(SupabaseConstants.touristSpotsTable)
      .select()
      .eq('destination_id', destinationId)
      .eq('is_featured', true);

  return (response as List)
      .map((e) => _spotFromJson(Map<String, dynamic>.from(e)))
      .toList();
});

/// Fetches all spots with GPS coordinates for map display.
final allMappableSpotsProvider = FutureProvider<List<Spot>>((ref) async {
  final response = await Supabase.instance.client
      .from(SupabaseConstants.touristSpotsTable)
      .select()
      .not('latitude', 'is', null)
      .not('longitude', 'is', null);

  return (response as List)
      .map((e) => _spotFromJson(Map<String, dynamic>.from(e)))
      .toList();
});

/// Fetches a single [Spot] by its ID from Supabase.
final spotByIdProvider =
    FutureProvider.family<Spot, ({String destinationId, String spotId})>(
  (ref, params) async {
    final response = await Supabase.instance.client
        .from(SupabaseConstants.touristSpotsTable)
        .select()
        .eq('id', params.spotId)
        .single();

    return _spotFromJson(Map<String, dynamic>.from(response));
  },
);
