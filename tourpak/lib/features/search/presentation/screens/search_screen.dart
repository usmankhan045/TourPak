import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../destinations/domain/entities/destination.dart';
import '../../../destinations/presentation/notifiers/destination_search_notifier.dart';

// ── Recent-search persistence helpers ────────────────────────

const _kRecentSearchesKey = 'recent_searches';
const _kMaxRecent = 8;

List<String> _loadRecentSearches() {
  final box = Hive.box(AppConstants.cacheBox);
  final raw = box.get(_kRecentSearchesKey);
  if (raw == null) return [];
  try {
    return (jsonDecode(raw as String) as List).cast<String>();
  } catch (_) {
    return [];
  }
}

void _saveRecentSearch(String query) {
  final box = Hive.box(AppConstants.cacheBox);
  final recent = _loadRecentSearches();
  recent.remove(query);
  recent.insert(0, query);
  if (recent.length > _kMaxRecent) recent.removeLast();
  box.put(_kRecentSearchesKey, jsonEncode(recent));
}

void _removeRecentSearch(String query) {
  final box = Hive.box(AppConstants.cacheBox);
  final recent = _loadRecentSearches();
  recent.remove(query);
  box.put(_kRecentSearchesKey, jsonEncode(recent));
}

void _clearRecentSearches() {
  final box = Hive.box(AppConstants.cacheBox);
  box.delete(_kRecentSearchesKey);
}

// ── Popular destination chips ────────────────────────────────

const _popularDestinations = [
  'Hunza',
  'Swat',
  'Naran',
  'Skardu',
  'Fairy Meadows',
  'Murree',
  'Chitral',
  'Kalash',
];

// ══════════════════════════════════════════════════════════════
// SEARCH SCREEN
// ══════════════════════════════════════════════════════════════

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _recentSearches = _loadRecentSearches();
    // Autofocus the search field after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    ref.read(destinationSearchProvider.notifier).onQueryChanged(query);
    setState(() {}); // rebuild to switch between states
  }

  void _onCancelTap() {
    ref.read(destinationSearchProvider.notifier).clear();
    context.pop();
  }

  void _onResultTap(Destination d) {
    _saveRecentSearch(d.name);
    context.push('/destination/${d.id}');
  }

  void _onRecentTap(String query) {
    _controller.text = query;
    _controller.selection =
        TextSelection.collapsed(offset: query.length);
    _onQueryChanged(query);
  }

  void _onPopularTap(String name) {
    _controller.text = name;
    _controller.selection =
        TextSelection.collapsed(offset: name.length);
    _onQueryChanged(name);
  }

  void _onRemoveRecent(String query) {
    _removeRecentSearch(query);
    setState(() => _recentSearches = _loadRecentSearches());
  }

  void _onClearAllRecent() {
    _clearRecentSearches();
    setState(() => _recentSearches = []);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(destinationSearchProvider);
    final topInset = MediaQuery.of(context).padding.top;
    final query = _controller.text.trim();

    return Scaffold(
      backgroundColor: TourPakColors.obsidian,
      body: Column(
        children: [
          // ── Top bar ──
          _SearchTopBar(
            topInset: topInset,
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onQueryChanged,
            onCancel: _onCancelTap,
          ),

          // ── Body ──
          Expanded(
            child: query.isEmpty
                ? _EmptyState(
                    recentSearches: _recentSearches,
                    onRecentTap: _onRecentTap,
                    onRemoveRecent: _onRemoveRecent,
                    onClearAll: _onClearAllRecent,
                    onPopularTap: _onPopularTap,
                  )
                : searchState.isLoading
                    ? const _LoadingState()
                    : searchState.results.isEmpty
                        ? _NoResultsState(query: query)
                        : _ResultsState(
                            results: searchState.results,
                            query: query,
                            onTap: _onResultTap,
                          ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// TOP BAR — GlassCard with back + search field + Cancel
// ══════════════════════════════════════════════════════════════

class _SearchTopBar extends StatelessWidget {
  final double topInset;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onCancel;

  const _SearchTopBar({
    required this.topInset,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TourPakColors.forestGreen,
      padding: EdgeInsets.only(top: topInset + 8, bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Back arrow
            GestureDetector(
              onTap: onCancel,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: TourPakColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Search field in glass card
            Expanded(
              child: GlassCard.dark(
                borderRadius: 28,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        color: TourPakColors.goldAction, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: onChanged,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: TourPakColors.textPrimary,
                        ),
                        cursorColor: TourPakColors.goldAction,
                        decoration: InputDecoration(
                          hintText: 'Search destinations...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 15,
                            color: TourPakColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          controller.clear();
                          onChanged('');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close_rounded,
                              color: TourPakColors.textSecondary, size: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Cancel text button
            GestureDetector(
              onTap: onCancel,
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TourPakColors.goldAction,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// STATE 1 — EMPTY (recent searches + popular chips)
// ══════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onRecentTap;
  final ValueChanged<String> onRemoveRecent;
  final VoidCallback onClearAll;
  final ValueChanged<String> onPopularTap;

  const _EmptyState({
    required this.recentSearches,
    required this.onRecentTap,
    required this.onRemoveRecent,
    required this.onClearAll,
    required this.onPopularTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      children: [
        // ── Recent searches ──
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: TourPakColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onClearAll,
                child: Text(
                  'Clear all',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: TourPakColors.goldMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentSearches.asMap().entries.map((entry) {
            return _RecentSearchItem(
              query: entry.value,
              onTap: () => onRecentTap(entry.value),
              onRemove: () => onRemoveRecent(entry.value),
            )
                .animate()
                .fadeIn(
                  duration: 300.ms,
                  delay: (entry.key * 50).ms,
                  curve: Curves.easeOut,
                )
                .slideX(
                  begin: -0.05,
                  end: 0,
                  duration: 300.ms,
                  delay: (entry.key * 50).ms,
                  curve: Curves.easeOut,
                );
          }),
          const SizedBox(height: 28),
        ],

        // ── Popular destinations ──
        Text(
          'Popular Destinations',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: TourPakColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularDestinations.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => onPopularTap(entry.value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  entry.value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TourPakColors.textPrimary,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(
                  duration: 300.ms,
                  delay: (entry.key * 40).ms,
                  curve: Curves.easeOut,
                )
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  duration: 300.ms,
                  delay: (entry.key * 40).ms,
                  curve: Curves.easeOut,
                );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Recent search item ───────────────────────────────────────

class _RecentSearchItem extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentSearchItem({
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.history_rounded,
                color: TourPakColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                query,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: TourPakColors.textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close_rounded,
                    color: TourPakColors.textSecondary, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// STATE 2 — RESULTS (live results with highlighted matches)
// ══════════════════════════════════════════════════════════════

class _ResultsState extends StatelessWidget {
  final List<Destination> results;
  final String query;
  final void Function(Destination) onTap;

  const _ResultsState({
    required this.results,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final d = results[index];
        return _SearchResultItem(
          destination: d,
          query: query,
          onTap: () => onTap(d),
        )
            .animate()
            .fadeIn(
              duration: 300.ms,
              delay: (index * 60).ms,
              curve: Curves.easeOut,
            )
            .slideX(
              begin: 0.05,
              end: 0,
              duration: 300.ms,
              delay: (index * 60).ms,
              curve: Curves.easeOut,
            );
      },
    );
  }
}

// ── Search result item with highlighted match ────────────────

class _SearchResultItem extends StatelessWidget {
  final Destination destination;
  final String query;
  final VoidCallback onTap;

  const _SearchResultItem({
    required this.destination,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 56,
                height: 56,
                child: CachedNetworkImage(
                  imageUrl: destination.heroImageUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      Container(color: TourPakColors.forestGreen),
                  errorWidget: (_, _, _) => Container(
                    color: TourPakColors.forestGreen,
                    child: const Icon(Icons.terrain_rounded,
                        color: TourPakColors.textSecondary, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name + province
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHighlightedName(),
                  if (destination.province != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      destination.province!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: TourPakColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Chevron
            const Icon(Icons.chevron_right_rounded,
                color: TourPakColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  /// Builds the destination name with the query substring highlighted in gold.
  Widget _buildHighlightedName() {
    final name = destination.name;
    final lowerName = name.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerName.indexOf(lowerQuery);

    if (matchIndex < 0 || query.isEmpty) {
      return Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: TourPakColors.textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final before = name.substring(0, matchIndex);
    final match = name.substring(matchIndex, matchIndex + query.length);
    final after = name.substring(matchIndex + query.length);

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: TourPakColors.textPrimary,
        ),
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          TextSpan(
            text: match,
            style: const TextStyle(color: TourPakColors.goldAction),
          ),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// STATE 3 — LOADING
// ══════════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: ListItemSkeleton(count: 5),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// STATE 4 — NO RESULTS
// ══════════════════════════════════════════════════════════════

class _NoResultsState extends StatelessWidget {
  final String query;

  const _NoResultsState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: TourPakColors.textSecondary,
            ),
            const SizedBox(height: 20),
            Text(
              'No destinations found',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: TourPakColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find anything matching "$query".\nTry a different search term.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TourPakColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
              duration: 400.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}
