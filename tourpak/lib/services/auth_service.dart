import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralised auth helper that wraps Supabase Auth methods.
///
/// Provides email/password sign-in, sign-up, Google sign-in, sign-out,
/// and password-reset functionality.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  SupabaseClient get _client => Supabase.instance.client;

  // ── Email + Password ──────────────────────────────────────

  /// Sign in with email and password.
  /// Throws [AuthException] on failure.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Create a new account with email, password, and optional display name.
  /// Throws [AuthException] on failure.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null && fullName.trim().isNotEmpty)
          'full_name': fullName.trim(),
      },
    );
  }

  // ── Google Sign-In ────────────────────────────────────────

  /// Authenticate via Google OAuth → Supabase session.
  /// Returns the [AuthResponse] or throws on failure.
  Future<AuthResponse> signInWithGoogle() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

    final googleSignIn = GoogleSignIn(
      serverClientId: webClientId.isNotEmpty ? webClientId : null,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Google sign-in was cancelled.');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw const AuthException('Failed to retrieve Google ID token.');
    }

    return await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // ── Password Reset ────────────────────────────────────────

  /// Sends a password-reset email via Supabase.
  Future<void> sendPasswordReset(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // ── Sign Out ──────────────────────────────────────────────

  Future<void> signOut() async {
    // Also sign out of Google if the user was signed in via Google.
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // Ignore — user may not have signed in via Google.
    }
    await _client.auth.signOut();
  }

  // ── Helpers ───────────────────────────────────────────────

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isLoggedIn => _client.auth.currentSession != null;

  /// Returns a user-friendly message from an [AuthException].
  static String friendlyError(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_credentials')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Please verify your email before signing in.';
    }
    if (msg.contains('user already registered') ||
        msg.contains('already been registered')) {
      return 'An account with this email already exists.';
    }
    if (msg.contains('rate limit') || msg.contains('too many requests')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'Network error. Check your connection and try again.';
    }
    return e.message;
  }
}
