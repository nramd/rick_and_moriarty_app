import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/core/error/failures.dart';
import 'package:rick_and_morty_app/features/character/domain/usecases/get_characters.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/character/character_bloc.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/character/character_event.dart';
import 'package:rick_and_morty_app/features/character/presentation/bloc/character/character_state.dart';

import '../../../../helpers/dummy_data.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late CharacterBloc bloc;
  late MockGetCharacters mockGetCharacters;

  setUp(() {
    mockGetCharacters = MockGetCharacters();
    bloc = CharacterBloc(getCharacters: mockGetCharacters);
  });

  // Register fallback values
  setUpAll(() {
    registerFallbackValue(const GetCharactersParams(page: 1));
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be CharacterState.initial()', () {
    expect(bloc.state, CharacterState.initial());
  });

  group('FetchCharactersEvent', () {
    blocTest<CharacterBloc, CharacterState>(
      'emits [loading, loaded] when FetchCharactersEvent is successful',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right(testCharacterList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchCharactersEvent()),
      expect: () => [
        CharacterState.initial().copyWith(status: CharacterStatus.loading),
        CharacterState.initial().copyWith(
          status: CharacterStatus.loaded,
          characters: testCharacterList,
          currentPage: 1,
          // testCharacterList has 2 items (< 20), so hasReachedMax is true
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verify(() => mockGetCharacters(const GetCharactersParams(page: 1)))
            .called(1);
      },
    );

    blocTest<CharacterBloc, CharacterState>(
      'emits [loading, error] when FetchCharactersEvent fails',
      build: () {
        when(() => mockGetCharacters(any())).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchCharactersEvent()),
      expect: () => [
        CharacterState.initial().copyWith(status: CharacterStatus.loading),
        CharacterState.initial().copyWith(
          status: CharacterStatus.error,
          errorMessage: 'Server error',
        ),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'emits hasReachedMax true when less than 20 characters returned',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right([testCharacter]));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchCharactersEvent()),
      expect: () => [
        CharacterState.initial().copyWith(status: CharacterStatus.loading),
        CharacterState.initial().copyWith(
          status: CharacterStatus.loaded,
          characters: [testCharacter],
          currentPage: 1,
          hasReachedMax: true,
        ),
      ],
    );
  });

  group('LoadMoreCharactersEvent', () {
    blocTest<CharacterBloc, CharacterState>(
      'emits [loadingMore, loaded] with appended characters when LoadMoreCharactersEvent is successful',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right([testCharacter2]));
        return bloc;
      },
      seed: () => CharacterState.initial().copyWith(
        status: CharacterStatus.loaded,
        characters: [testCharacter],
        currentPage: 1,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const LoadMoreCharactersEvent()),
      expect: () => [
        CharacterState.initial().copyWith(
          status: CharacterStatus.loadingMore,
          characters: [testCharacter],
          currentPage: 1,
          hasReachedMax: false,
        ),
        CharacterState.initial().copyWith(
          status: CharacterStatus.loaded,
          characters: [testCharacter, testCharacter2],
          currentPage: 2,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verify(() => mockGetCharacters(const GetCharactersParams(page: 2)))
            .called(1);
      },
    );

    blocTest<CharacterBloc, CharacterState>(
      'does not emit when hasReachedMax is true',
      build: () => bloc,
      seed: () => CharacterState.initial().copyWith(
        status: CharacterStatus.loaded,
        characters: testCharacterList,
        currentPage: 42,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const LoadMoreCharactersEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetCharacters(any()));
      },
    );

    blocTest<CharacterBloc, CharacterState>(
      'does not emit when already loading more',
      build: () => bloc,
      seed: () => CharacterState.initial().copyWith(
        status: CharacterStatus.loadingMore,
        characters: testCharacterList,
        currentPage: 1,
        hasReachedMax: false,
      ),
      act: (bloc) => bloc.add(const LoadMoreCharactersEvent()),
      expect: () => [],
    );
  });

  group('RefreshCharactersEvent', () {
    blocTest<CharacterBloc, CharacterState>(
      'emits [loaded] with fresh data when RefreshCharactersEvent is successful',
      build: () {
        when(() => mockGetCharacters(any()))
            .thenAnswer((_) async => const Right(testCharacterList));
        return bloc;
      },
      seed: () => CharacterState.initial().copyWith(
        status: CharacterStatus.loaded,
        characters: [testCharacter],
        currentPage: 5,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const RefreshCharactersEvent()),
      expect: () => [
        CharacterState.initial().copyWith(
          status: CharacterStatus.loaded,
          characters: testCharacterList,
          currentPage: 1,
          // testCharacterList has 2 items (< 20), so hasReachedMax is true
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        verify(() => mockGetCharacters(const GetCharactersParams(page: 1)))
            .called(1);
      },
    );

    blocTest<CharacterBloc, CharacterState>(
      'emits [error] when RefreshCharactersEvent fails',
      build: () {
        when(() => mockGetCharacters(any())).thenAnswer(
            (_) async => const Left(NetworkFailure(message: 'No internet')));
        return bloc;
      },
      seed: () => CharacterState.initial().copyWith(
        status: CharacterStatus.loaded,
        characters: testCharacterList,
        currentPage: 1,
      ),
      act: (bloc) => bloc.add(const RefreshCharactersEvent()),
      expect: () => [
        CharacterState.initial().copyWith(
          status: CharacterStatus.error,
          errorMessage: 'No internet',
          characters: testCharacterList,
          currentPage: 1,
        ),
      ],
    );
  });
}
