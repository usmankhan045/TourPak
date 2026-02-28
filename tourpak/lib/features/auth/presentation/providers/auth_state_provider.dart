import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Watches the Supabase auth state and exposes it as a Riverpod stream.
///
/// Returns `true` when a user session exists, `false` otherwise.
final authStateProvider = StreamProvider<bool>((ref) {
  final controller = StreamController<bool>();

  // Emit current state immediately
  final currentSession = Supabase.instance.client.auth.currentSession;
  controller.add(currentSession != null);

  // Listen for auth changes
  final subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
    (AuthState data) {
      controller.add(data.session != null);
    },
  );

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Synchronous check: is the user currently authenticated?
bool isAuthenticated() {
  return Supabase.instance.client.auth.currentSession != null;
}
