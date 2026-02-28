import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  Future<Either<Failure, void>> call(String phone) {
    return _repository.sendOtp(phone);
  }
}
