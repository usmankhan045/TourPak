import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';
import 'package:tourpak/features/destinations/domain/repositories/destination_repository.dart';

class SearchDestinationsUseCase {
  final DestinationRepository _repository;

  const SearchDestinationsUseCase(this._repository);

  Future<Either<Failure, List<Destination>>> call(String query) {
    return _repository.searchDestinations(query);
  }
}
