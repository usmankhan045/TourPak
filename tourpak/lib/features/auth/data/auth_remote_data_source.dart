import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles all Supabase auth API calls.
class AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Sends a one-time password to [phoneNumber].
  /// Phone must include country code, e.g. "+923001234567".
  Future<void> sendOtp(String phoneNumber) async {
    await _client.auth.signInWithOtp(phone: phoneNumber);
  }

  /// Verifies the OTP [token] sent to [phone].
  Future<AuthResponse> verifyOtp(String phone, String token) async {
    return await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Returns the currently signed-in Supabase user, or null.
  User? get currentUser => _client.auth.currentUser;
}
