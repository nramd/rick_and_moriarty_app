import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/core/error/failures.dart';
import 'package:rick_and_morty_app/features/character/data/repositories/character_repository_impl.dart';

import '../../../../helpers/dummy_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late CharacterRepositoryImpl repository;
  late MockCharacterRemoteDataSource mockRemoteDataSource;
  late MockCharacterLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockCharacterRemoteDataSource();
    mockLocalDataSource = MockCharacterLocalDataSource();
    repository = CharacterRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(testCharacterModel);
  });

  group('getCharacters', () {
    test(
      'should return list of characters when remote data source call is successful',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.getCharacters(page: 1))
            .thenAnswer((_) async => testCharacterResponseModel);

        // Act
        final result = await repository.getCharacters(page: 1);

        // Assert
        expect(result. isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (characters) {
            expect(characters.length, 1);
            expect(characters. first.name, 'Rick Sanchez');
          },
        );
        verify(() => mockRemoteDataSource.getCharacters(page: 1)).called(1);
      },
    );

    test(
      'should return ServerFailure when remote data source throws ServerException',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.getCharacters(page: 1))
            .thenThrow(ServerException(message: 'Server error'));

        // Act
        final result = await repository.getCharacters(page: 1);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, 'Server error');
          },
          (characters) => fail('Should not return characters'),
        );
      },
    );

    test(
      'should return NetworkFailure when remote data source throws NetworkException',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.getCharacters(page: 1))
            .thenThrow(NetworkException(message: 'No internet'));

        // Act
        final result = await repository.getCharacters(page: 1);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>());
          },
          (characters) => fail('Should not return characters'),
        );
      },
    );
  });

  group('getFavorites', () {
    test(
      'should return list of favorite characters from local data source',
      () async {
        // Arrange
        when(() => mockLocalDataSource. getFavorites())
            .thenAnswer((_) async => testCharacterModelList);

        // Act
        final result = await repository.getFavorites();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (favorites) {
            expect(favorites.length, 1);
            expect(favorites.first. name, 'Rick Sanchez');
          },
        );
        verify(() => mockLocalDataSource.getFavorites()).called(1);
      },
    );

    test(
      'should return CacheFailure when local data source throws CacheException',
      () async {
        // Arrange
        when(() => mockLocalDataSource. getFavorites())
            .thenThrow(CacheException(message: 'Cache error'));

        // Act
        final result = await repository.getFavorites();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<CacheFailure>());
          },
          (favorites) => fail('Should not return favorites'),
        );
      },
    );
  });

  group('addFavorite', () {
    test(
      'should add character to favorites successfully',
      () async {
        // Arrange
        when(() => mockLocalDataSource.addFavorite(any()))
            .thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.addFavorite(testCharacter);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockLocalDataSource.addFavorite(any())).called(1);
      },
    );

    test(
      'should return CacheFailure when adding favorite fails',
      () async {
        // Arrange
        when(() => mockLocalDataSource.addFavorite(any()))
            .thenThrow(CacheException(message: 'Failed to add'));

        // Act
        final result = await repository.addFavorite(testCharacter);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Should not succeed'),
        );
      },
    );
  });

  group('removeFavorite', () {
    test(
      'should remove character from favorites successfully',
      () async {
        // Arrange
        when(() => mockLocalDataSource.removeFavorite(1))
            .thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.removeFavorite(1);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockLocalDataSource.removeFavorite(1)).called(1);
      },
    );
  });

  group('searchCharacters', () {
    test(
      'should return search results when successful',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.searchCharacters(name: 'Rick', page: 1))
            .thenAnswer((_) async => testCharacterResponseModel);

        // Act
        final result = await repository.searchCharacters(name: 'Rick', page: 1);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (characters) {
            expect(characters.length, 1);
            expect(characters.first.name, 'Rick Sanchez');
          },
        );
      },
    );
  });
}