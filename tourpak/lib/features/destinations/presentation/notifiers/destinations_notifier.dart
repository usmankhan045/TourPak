import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourpak/features/destinations/data/destination_local_data_source.dart';
import 'package:tourpak/features/destinations/data/destination_remote_data_source.dart';
import 'package:tourpak/features/destinations/data/destination_repository_impl.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';
import 'package:tourpak/features/destinations/domain/repositories/destination_repository.dart';
import 'package:tourpak/features/destinations/domain/usecases/get_all_destinations_usecase.dart';
import 'package:tourpak/features/destinations/domain/usecases/get_destination_by_id_usecase.dart';
import 'package:tourpak/features/destinations/domain/usecases/search_destinations_usecase.dart';

// ── Provider chain ─────────────────────────────────────────

final _remoteDataSourceProvider = Provider<DestinationRemoteDataSource>((ref) {
  return DestinationRemoteDataSource();
});

final _localDataSourceProvider = Provider<DestinationLocalDataSource>((ref) {
  return DestinationLocalDataSource();
});

final _destinationRepositoryProvider = Provider<DestinationRepository>((ref) {
  return DestinationRepositoryImpl(
    ref.watch(_remoteDataSourceProvider),
    ref.watch(_localDataSourceProvider),
  );
});

final _getAllDestinationsUseCaseProvider =
    Provider<GetAllDestinationsUseCase>((ref) {
  return GetAllDestinationsUseCase(ref.watch(_destinationRepositoryProvider));
});

final _getDestinationByIdUseCaseProvider =
    Provider<GetDestinationByIdUseCase>((ref) {
  return GetDestinationByIdUseCase(ref.watch(_destinationRepositoryProvider));
});

/// Exposed for the search notifier.
final searchDestinationsUseCaseProvider =
    Provider<SearchDestinationsUseCase>((ref) {
  return SearchDestinationsUseCase(ref.watch(_destinationRepositoryProvider));
});

// ── Destinations list (AsyncNotifier) ──────────────────────

final destinationsProvider =
    AsyncNotifierProvider<DestinationsNotifier, List<Destination>>(() {
  return DestinationsNotifier();
});

class DestinationsNotifier extends AsyncNotifier<List<Destination>> {
  @override
  Future<List<Destination>> build() async {
    final destinations = await _fetch();

    // Stale-while-revalidate: serve cache immediately, refresh in background.
    _refreshInBackground();

    return destinations;
  }

  Future<List<Destination>> _fetch() async {
    final useCase = ref.read(_getAllDestinationsUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (destinations) => destinations,
    );
  }

  Future<void> _refreshInBackground() async {
    try {
      final useCase = ref.read(_getAllDestinationsUseCaseProvider);
      final result = await useCase(forceRefresh: true);
      result.fold(
        (_) {}, // Silently ignore background failures.
        (fresh) => state = AsyncData(fresh),
      );
    } catch (_) {
      // Silently fail — we already have data showing.
    }
  }

  /// Pull-to-refresh: always fetches from remote.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(_getAllDestinationsUseCaseProvider);
      final result = await useCase(forceRefresh: true);
      return result.fold(
        (failure) => throw Exception(failure.message),
        (destinations) => destinations,
      );
    });
  }
}

// ── Single destination by ID ───────────────────────────────

final destinationByIdProvider =
    FutureProvider.family<Destination, String>((ref, id) async {
  final useCase = ref.watch(_getDestinationByIdUseCaseProvider);
  final result = await useCase(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (destination) => destination,
  );
});
