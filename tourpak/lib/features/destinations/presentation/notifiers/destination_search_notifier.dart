import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';
import 'package:tourpak/features/destinations/domain/usecases/search_destinations_usecase.dart';
import 'package:tourpak/features/destinations/presentation/notifiers/destinations_notifier.dart';

// ── Search state ──────────────────────────────────────────

class DestinationSearchState {
  final String query;
  final List<Destination> results;
  final bool isLoading;
  final String? errorMessage;

  const DestinationSearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  DestinationSearchState copyWith({
    String? query,
    List<Destination>? results,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DestinationSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// ── Provider ──────────────────────────────────────────────

final destinationSearchProvider = StateNotifierProvider<
    DestinationSearchNotifier, DestinationSearchState>((ref) {
  return DestinationSearchNotifier(
    searchUseCase: ref.watch(searchDestinationsUseCaseProvider),
  );
});

// ── Notifier ──────────────────────────────────────────────

class DestinationSearchNotifier extends StateNotifier<DestinationSearchState> {
  final SearchDestinationsUseCase _searchUseCase;
  Timer? _debounceTimer;

  DestinationSearchNotifier({
    required SearchDestinationsUseCase searchUseCase,
  })  : _searchUseCase = searchUseCase,
        super(const DestinationSearchState());

  /// Call this from the search text-field's onChanged.
  /// Debounces by 300 ms before firing the Supabase query.
  void onQueryChanged(String query) {
    state = state.copyWith(query: query);

    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true);

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _search(query.trim());
    });
  }

  Future<void> _search(String query) async {
    final result = await _searchUseCase(query);

    if (!mounted) return;

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (destinations) => state = state.copyWith(
        results: destinations,
        isLoading: false,
      ),
    );
  }

  /// Resets the search to its initial empty state.
  void clear() {
    _debounceTimer?.cancel();
    state = const DestinationSearchState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
