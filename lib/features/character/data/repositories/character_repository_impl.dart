import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_local_datasource.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';
import '../models/character_response_model.dart';

/// Implementation of CharacterRepository
class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Character>>> getCharacters({int page = 1}) async {
    try {
      final response = await remoteDataSource.getCharacters(page: page);
      return Right(response.results);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Character>> getCharacterById(int id) async {
    try {
      final character = await remoteDataSource.getCharacterById(id);
      return Right(character);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Character>>> searchCharacters({
    required String name,
    int page = 1,
  }) async {
    try {
      final response = await remoteDataSource.searchCharacters(
        name: name,
        page: page,
      );
      return Right(response.results);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Character>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Cache error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(Character character) async {
    try {
      final characterModel = CharacterModel.fromEntity(character);
      await localDataSource.addFavorite(characterModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Cache error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int characterId) async {
    try {
      await localDataSource.removeFavorite(characterId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Cache error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int characterId) async {
    try {
      final isFav = await localDataSource.isFavorite(characterId);
      return Right(isFav);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message ?? 'Cache error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginationInfo>> getPaginationInfo(
      {int page = 1}) async {
    try {
      final response = await remoteDataSource.getCharacters(page: page);
      return Right(_createPaginationInfo(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginationInfo>> getSearchPaginationInfo({
    required String name,
    int page = 1,
  }) async {
    try {
      final response = await remoteDataSource.searchCharacters(
        name: name,
        page: page,
      );
      return Right(_createPaginationInfo(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error'));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Create pagination info from response
  PaginationInfo _createPaginationInfo(CharacterResponseModel response) {
    return PaginationInfo(
      totalCount: response.info.count,
      totalPages: response.info.pages,
      currentPage: response.currentPage,
      hasNextPage: response.hasNextPage,
      hasPreviousPage: response.hasPreviousPage,
    );
  }
}
