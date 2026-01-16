import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/character.dart';

/// Abstract repository interface for character feature
abstract class CharacterRepository {
  /// Get all characters with pagination
  Future<Either<Failure, List<Character>>> getCharacters({int page = 1});

  /// Get single character by ID
  Future<Either<Failure, Character>> getCharacterById(int id);

  /// Search characters by name
  Future<Either<Failure, List<Character>>> searchCharacters({
    required String name,
    int page = 1,
  });

  /// Get all favorite characters
  Future<Either<Failure, List<Character>>> getFavorites();

  /// Add character to favorites
  Future<Either<Failure, void>> addFavorite(Character character);

  /// Remove character from favorites
  Future<Either<Failure, void>> removeFavorite(int characterId);

  /// Check if character is in favorites
  Future<Either<Failure, bool>> isFavorite(int characterId);

  /// Get pagination info
  Future<Either<Failure, PaginationInfo>> getPaginationInfo({int page = 1});

  /// Search with pagination info
  Future<Either<Failure, PaginationInfo>> getSearchPaginationInfo({
    required String name,
    int page = 1,
  });
}

/// Pagination info class
class PaginationInfo {
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationInfo({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}
