import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';
import 'package:tourpak/features/destinations/domain/repositories/destination_repository.dart';

class GetDestinationByIdUseCase {
  final DestinationRepository _repository;

  const GetDestinationByIdUseCase(this._repository);

  Future<Either<Failure, Destination>> call(String id) {
    return _repository.getDestinationById(id);
  }
}
