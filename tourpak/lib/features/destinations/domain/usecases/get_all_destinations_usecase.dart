import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';
import 'package:tourpak/features/destinations/domain/repositories/destination_repository.dart';

class GetAllDestinationsUseCase {
  final DestinationRepository _repository;

  const GetAllDestinationsUseCase(this._repository);

  Future<Either<Failure, List<Destination>>> call({
    bool forceRefresh = false,
  }) {
    if (forceRefresh) {
      return _repository.refreshDestinations();
    }
    return _repository.getAllDestinations();
  }
}
