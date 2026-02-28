/// Base failure class for TourPak error handling.
class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure($message)';
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}
