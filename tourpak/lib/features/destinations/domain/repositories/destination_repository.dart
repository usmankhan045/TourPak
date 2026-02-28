import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';

/// Contract for destination data operations.
abstract interface class DestinationRepository {
  Future<Either<Failure, List<Destination>>> getAllDestinations();
  Future<Either<Failure, List<Destination>>> refreshDestinations();
  Future<Either<Failure, Destination>> getDestinationById(String id);
  Future<Either<Failure, List<Destination>>> searchDestinations(String query);
}
