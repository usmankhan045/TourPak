import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourpak/core/constants/supabase_constants.dart';
import 'package:tourpak/features/destinations/data/dtos/destination_dto.dart';

/// Handles all Supabase queries for the destinations table.
class DestinationRemoteDataSource {
  final SupabaseClient _client;

  DestinationRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetches all destinations, featured first.
  Future<List<DestinationDto>> getAllDestinations() async {
    final response = await _client
        .from(SupabaseConstants.destinationsTable)
        .select()
        .order('is_featured', ascending: false);

    return (response as List)
        .map((e) => DestinationDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Fetches a single destination by [id].
  Future<DestinationDto> getDestinationById(String id) async {
    final response = await _client
        .from(SupabaseConstants.destinationsTable)
        .select()
        .eq('id', id)
        .single();

    return DestinationDto.fromJson(Map<String, dynamic>.from(response));
  }

  /// Searches destinations by name (case-insensitive partial match).
  Future<List<DestinationDto>> searchDestinations(String query) async {
    final response = await _client
        .from(SupabaseConstants.destinationsTable)
        .select()
        .ilike('name', '%$query%');

    return (response as List)
        .map((e) => DestinationDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
