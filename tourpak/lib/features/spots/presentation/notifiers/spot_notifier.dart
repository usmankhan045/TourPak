import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourpak/core/constants/supabase_constants.dart';

import '../../domain/entities/spot.dart';

/// Fetches tourist spots for a given destination from Supabase.
final spotsByDestinationProvider =
    FutureProvider.family<List<Spot>, String>((ref, destinationId) async {
  final response = await Supabase.instance.client
      .from(SupabaseConstants.touristSpotsTable)
      .select()
      .eq('destination_id', destinationId)
      .limit(10);

  return (response as List).map((e) {
    final j = Map<String, dynamic>.from(e);
    return Spot(
      id: j['id'] as String,
      name: j['name'] as String,
      destinationId: j['destination_id'] as String,
      category: j['category'] as String?,
      heroImageUrl: j['hero_image_url'] as String?,
      galleryUrls:
          (j['gallery_urls'] as List<dynamic>?)?.cast<String>() ?? [],
      description: j['description'] as String?,
      altitude: (j['altitude_meters'] as num?)?.toDouble(),
      entryFee: j['entry_fee'] as String?,
      hours: j['visiting_hours'] as String?,
      latitude: (j['latitude'] as num?)?.toDouble(),
      longitude: (j['longitude'] as num?)?.toDouble(),
    );
  }).toList();
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

    final j = Map<String, dynamic>.from(response);
    return Spot(
      id: j['id'] as String,
      name: j['name'] as String,
      destinationId: j['destination_id'] as String,
      category: j['category'] as String?,
      heroImageUrl: j['hero_image_url'] as String?,
      galleryUrls:
          (j['gallery_urls'] as List<dynamic>?)?.cast<String>() ?? [],
      description: j['description'] as String?,
      bestTime: j['best_time'] as String?,
      altitude: (j['altitude_meters'] as num?)?.toDouble(),
      entryFee: j['entry_fee'] as String?,
      hours: j['visiting_hours'] as String?,
      latitude: (j['latitude'] as num?)?.toDouble(),
      longitude: (j['longitude'] as num?)?.toDouble(),
    );
  },
);
