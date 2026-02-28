import 'package:tourpak/core/error/failures.dart';
import 'package:tourpak/core/utils/either.dart';
import 'package:tourpak/features/destinations/data/destination_local_data_source.dart';
import 'package:tourpak/features/destinations/data/destination_remote_data_source.dart';
import 'package:tourpak/features/destinations/domain/entities/destination.dart';
import 'package:tourpak/features/destinations/domain/repositories/destination_repository.dart';

class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationRemoteDataSource _remoteDataSource;
  final DestinationLocalDataSource _localDataSource;

  DestinationRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<Destination>>> getAllDestinations() async {
    try {
      // Return cache immediately if available (stale-while-revalidate).
      final cached = await _localDataSource.getCachedDestinations();
      if (cached != null) {
        return Right(cached.map((dto) => dto.toEntity()).toList());
      }

      // No cache — must fetch from remote.
      final dtos = await _remoteDataSource.getAllDestinations();
      await _localDataSource.cacheDestinations(dtos);
      return Right(dtos.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Destination>>> refreshDestinations() async {
    try {
      final dtos = await _remoteDataSource.getAllDestinations();
      await _localDataSource.cacheDestinations(dtos);
      return Right(dtos.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      // If remote fails, fall back to stale cache.
      final cached = await _localDataSource.getCachedDestinations();
      if (cached != null) {
        return Right(cached.map((dto) => dto.toEntity()).toList());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Destination>> getDestinationById(String id) async {
    try {
      final dto = await _remoteDataSource.getDestinationById(id);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Destination>>> searchDestinations(
    String query,
  ) async {
    try {
      final dtos = await _remoteDataSource.searchDestinations(query);
      return Right(dtos.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
