/// Minimal Either type for use-case return values.
///
/// Avoids pulling in the full `dartz` or `fpdart` package for a single type.
sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight);

  bool get isLeft;
  bool get isRight;
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) => onLeft(value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) => onRight(value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;
}
