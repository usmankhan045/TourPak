import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourpak/core/theme/colors.dart';

// ── Connectivity state ──────────────────────────────────────

enum ConnectivityStatus { online, offline }

// ── Provider ────────────────────────────────────────────────

final connectivityProvider =
    StreamNotifierProvider<ConnectivityNotifier, ConnectivityStatus>(() {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends StreamNotifier<ConnectivityStatus> {
  @override
  Stream<ConnectivityStatus> build() {
    return Connectivity()
        .onConnectivityChanged
        .map((results) => _mapResults(results));
  }

  ConnectivityStatus _mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return ConnectivityStatus.offline;
    }
    return ConnectivityStatus.online;
  }
}

// ── Offline banner widget ───────────────────────────────────

/// Persistent amber banner shown at the bottom of the screen when
/// connectivity is lost.
///
/// Wrap your scaffold body or place this in a [Column] / [Stack]:
/// ```dart
/// Column(
///   children: [
///     Expanded(child: yourContent),
///     const OfflineBanner(),
///   ],
/// )
/// ```
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);

    final isOffline = connectivity.whenOrNull(
          data: (status) => status == ConnectivityStatus.offline,
        ) ??
        false;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isOffline
          ? Container(
              key: const ValueKey('offline_banner'),
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16,
                10,
                16,
                MediaQuery.paddingOf(context).bottom + 10,
              ),
              color: TourPakColors.warningAmber,
              child: Text(
                '\u{1F4F6} You are offline \u2014 showing cached data',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: TourPakColors.obsidian,
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('online')),
    );
  }
}
