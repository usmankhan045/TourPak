import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/auth/domain/entities/auth_user.dart';
import 'package:tourpak/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  Future<Either<Failure, AuthUser>> call(String phone, String otp) {
    return _repository.verifyOtp(phone, otp);
  }
}
