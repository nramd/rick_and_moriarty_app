import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/core/error/failures.dart';
import 'package:rick_and_morty_app/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/features/character/domain/usecases/get_characters.dart';

import '../../../../helpers/dummy_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late GetCharacters usecase;
  late MockCharacterRepository mockRepository;

  setUp(() {
    mockRepository = MockCharacterRepository();
    usecase = GetCharacters(mockRepository);
  });

  group('GetCharacters UseCase', () {
    test(
      'should get list of characters from repository when call is successful',
      () async {
        // Arrange
        when(() => mockRepository.getCharacters(page: 1))
            .thenAnswer((_) async => const Right(testCharacterList));

        // Act
        final result = await usecase(const GetCharactersParams(page: 1));

        // Assert
        expect(result, const Right(testCharacterList));
        verify(() => mockRepository.getCharacters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return ServerFailure when repository call fails',
      () async {
        // Arrange
        const failure = ServerFailure(message: 'Server error');
        when(() => mockRepository.getCharacters(page: 1))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(const GetCharactersParams(page: 1));

        // Assert
        expect(result, const Left(failure));
        verify(() => mockRepository.getCharacters(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return empty list when no characters found',
      () async {
        // Arrange
        when(() => mockRepository.getCharacters(page: 100))
            .thenAnswer((_) async => const Right([]));

        // Act
        final result = await usecase(const GetCharactersParams(page: 100));

        // Assert
        expect(result, const Right(<Character>[]));
        verify(() => mockRepository.getCharacters(page: 100)).called(1);
      },
    );

    test(
      'should use default page 1 when not specified',
      () async {
        // Arrange
        when(() => mockRepository.getCharacters(page: 1))
            .thenAnswer((_) async => const Right(testCharacterList));

        // Act
        final result = await usecase(const GetCharactersParams());

        // Assert
        expect(result, const Right(testCharacterList));
        verify(() => mockRepository.getCharacters(page: 1)).called(1);
      },
    );
  });
}