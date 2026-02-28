import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/auth/domain/entities/auth_user.dart';

/// Contract for authentication operations.
abstract interface class AuthRepository {
  Future<Either<Failure, void>> sendOtp(String phone);
  Future<Either<Failure, AuthUser>> verifyOtp(String phone, String otp);
  Future<Either<Failure, void>> signOut();
  AuthUser? get currentUser;
}
