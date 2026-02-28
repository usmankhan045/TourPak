import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/auth/data/auth_remote_data_source.dart';
import 'package:tourpak/features/auth/domain/entities/auth_user.dart';
import 'package:tourpak/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> sendOtp(String phone) async {
    try {
      await _dataSource.sendOtp(phone);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> verifyOtp(String phone, String otp) async {
    try {
      final response = await _dataSource.verifyOtp(phone, otp);
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('Verification failed. Please try again.'));
      }
      return Right(AuthUser(
        id: user.id,
        phone: user.phone ?? phone,
        isNewUser: user.createdAt == user.updatedAt,
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  AuthUser? get currentUser {
    final user = _dataSource.currentUser;
    if (user == null) return null;
    return AuthUser(
      id: user.id,
      phone: user.phone ?? '',
    );
  }
}
