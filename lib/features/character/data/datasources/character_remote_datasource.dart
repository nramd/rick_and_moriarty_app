import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/character_model.dart';
import '../models/character_response_model.dart';

/// Abstract class for remote data source
abstract class CharacterRemoteDataSource {
  /// Get all characters with pagination
  /// [page] - page number (starts from 1)
  Future<CharacterResponseModel> getCharacters({int page = 1});

  /// Get single character by ID
  /// [id] - character ID
  Future<CharacterModel> getCharacterById(int id);

  /// Search characters by name
  /// [name] - search query
  /// [page] - page number for pagination
  Future<CharacterResponseModel> searchCharacters({
    required String name,
    int page = 1,
  });
}

/// Implementation of CharacterRemoteDataSource
class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final ApiClient apiClient;

  CharacterRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CharacterResponseModel> getCharacters({int page = 1}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.character,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        return CharacterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to fetch characters',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch characters',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<CharacterModel> getCharacterById(int id) async {
    try {
      final response = await apiClient.get('${ApiConstants.character}/$id');

      if (response.statusCode == 200) {
        return CharacterModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to fetch character detail',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch character detail',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<CharacterResponseModel> searchCharacters({
    required String name,
    int page = 1,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.character,
        queryParameters: {
          'name': name,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return CharacterResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to search characters',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // API returns 404 when no results found
      if (e.response?.statusCode == 404) {
        return const CharacterResponseModel(
          info: CharacterInfoModel(count: 0, pages: 0),
          results: [],
        );
      }
      throw ServerException(
        message: e.message ?? 'Failed to search characters',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
