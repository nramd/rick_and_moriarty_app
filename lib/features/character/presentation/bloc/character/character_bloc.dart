import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_characters.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharacters getCharacters;

  CharacterBloc({required this.getCharacters})
      : super(CharacterState.initial()) {
    on<FetchCharactersEvent>(_onFetchCharacters);
    on<LoadMoreCharactersEvent>(_onLoadMoreCharacters);
    on<RefreshCharactersEvent>(_onRefreshCharacters);
  }

  Future<void> _onFetchCharacters(
    FetchCharactersEvent event,
    Emitter<CharacterState> emit,
  ) async {
    emit(state.copyWith(status: CharacterStatus.loading));

    final result = await getCharacters(const GetCharactersParams(page: 1));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CharacterStatus.error,
        errorMessage: failure.message,
      )),
      (characters) => emit(state.copyWith(
        status: CharacterStatus.loaded,
        characters: characters,
        currentPage: 1,
        hasReachedMax: characters.length < 20,
      )),
    );
  }

  Future<void> _onLoadMoreCharacters(
    LoadMoreCharactersEvent event,
    Emitter<CharacterState> emit,
  ) async {
    if (state.hasReachedMax || state.status == CharacterStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: CharacterStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await getCharacters(GetCharactersParams(page: nextPage));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CharacterStatus.loaded,
        hasReachedMax: true,
      )),
      (characters) => emit(state.copyWith(
        status: CharacterStatus.loaded,
        characters: [...state.characters, ...characters],
        currentPage: nextPage,
        hasReachedMax: characters.length < 20,
      )),
    );
  }

  Future<void> _onRefreshCharacters(
    RefreshCharactersEvent event,
    Emitter<CharacterState> emit,
  ) async {
    final result = await getCharacters(const GetCharactersParams(page: 1));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CharacterStatus.error,
        errorMessage: failure.message,
      )),
      (characters) => emit(state.copyWith(
        status: CharacterStatus.loaded,
        characters: characters,
        currentPage: 1,
        hasReachedMax: characters.length < 20,
      )),
    );
  }
}
