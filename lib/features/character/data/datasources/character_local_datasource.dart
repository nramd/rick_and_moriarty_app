import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../models/character_model.dart';

/// Abstract class for local data source
abstract class CharacterLocalDataSource {
  /// Get all favorite characters
  Future<List<CharacterModel>> getFavorites();

  /// Add character to favorites
  Future<void> addFavorite(CharacterModel character);

  /// Remove character from favorites
  Future<void> removeFavorite(int characterId);

  /// Check if character is in favorites
  Future<bool> isFavorite(int characterId);

  /// Get single favorite character by ID
  Future<CharacterModel?> getFavoriteById(int characterId);
}

/// Implementation of CharacterLocalDataSource
class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  final DatabaseHelper databaseHelper;

  CharacterLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CharacterModel>> getFavorites() async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        AppConstants.favoriteTable,
        orderBy: 'added_at DESC',
      );

      return result.map((map) => CharacterModel.fromDatabase(map)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> addFavorite(CharacterModel character) async {
    try {
      final db = await databaseHelper.database;

      // Check if already exists
      final existing = await db.query(
        AppConstants.favoriteTable,
        where: 'id = ?',
        whereArgs: [character.id],
      );

      if (existing.isNotEmpty) {
        throw CacheException(message: 'Character already in favorites');
      }

      // Add to database with timestamp
      final data = character.toDatabase();
      data['added_at'] = DateTime.now().toIso8601String();

      await db.insert(
        AppConstants.favoriteTable,
        data,
      );
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to add favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(int characterId) async {
    try {
      final db = await databaseHelper.database;
      final rowsDeleted = await db.delete(
        AppConstants.favoriteTable,
        where: 'id = ?',
        whereArgs: [characterId],
      );

      if (rowsDeleted == 0) {
        throw CacheException(message: 'Character not found in favorites');
      }
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
          message: 'Failed to remove favorite: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        AppConstants.favoriteTable,
        where: 'id = ?',
        whereArgs: [characterId],
      );

      return result.isNotEmpty;
    } catch (e) {
      throw CacheException(
          message: 'Failed to check favorite: ${e.toString()}');
    }
  }

  @override
  Future<CharacterModel?> getFavoriteById(int characterId) async {
    try {
      final db = await databaseHelper.database;
      final result = await db.query(
        AppConstants.favoriteTable,
        where: 'id = ?',
        whereArgs: [characterId],
      );

      if (result.isEmpty) return null;
      return CharacterModel.fromDatabase(result.first);
    } catch (e) {
      throw CacheException(message: 'Failed to get favorite: ${e.toString()}');
    }
  }
}
