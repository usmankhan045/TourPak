import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourpak/features/auth/data/auth_remote_data_source.dart';
import 'package:tourpak/features/auth/data/auth_repository_impl.dart';
import 'package:tourpak/features/auth/domain/entities/auth_user.dart';
import 'package:tourpak/features/auth/domain/repositories/auth_repository.dart';
import 'package:tourpak/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:tourpak/features/auth/domain/usecases/verify_otp_usecase.dart';

// ── Auth state ──────────────────────────────────────────────

enum AuthStatus {
  idle,
  sendingOtp,
  otpSent,
  verifying,
  authenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;
  final String phone;

  const AuthState({
    this.status = AuthStatus.idle,
    this.user,
    this.errorMessage,
    this.phone = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    String? phone,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      phone: phone ?? this.phone,
    );
  }
}

// ── Providers ───────────────────────────────────────────────

final _authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final _authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(_authDataSourceProvider));
});

final _sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  return SendOtpUseCase(ref.watch(_authRepositoryProvider));
});

final _verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.watch(_authRepositoryProvider));
});

// ── Notifier ────────────────────────────────────────────────

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    sendOtpUseCase: ref.watch(_sendOtpUseCaseProvider),
    verifyOtpUseCase: ref.watch(_verifyOtpUseCaseProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  AuthNotifier({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        super(const AuthState());

  /// Sends an OTP to [phone] (must include +92 prefix).
  Future<void> sendOtp(String phone) async {
    state = state.copyWith(status: AuthStatus.sendingOtp, phone: phone);

    final result = await _sendOtpUseCase(phone);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: AuthStatus.otpSent),
    );
  }

  /// Verifies the OTP code. Uses the phone stored from [sendOtp].
  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(status: AuthStatus.verifying);

    final result = await _verifyOtpUseCase(state.phone, otp);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  /// Resets back to idle (e.g., user presses back from OTP screen).
  void reset() {
    state = const AuthState();
  }
}
