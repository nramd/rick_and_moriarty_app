import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/search_characters.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchCharacters searchCharacters;

  SearchBloc({required this.searchCharacters}) : super(SearchState.initial()) {
    on<SearchCharactersEvent>(_onSearchCharacters);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchCharacters(
    SearchCharactersEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchState.initial());
      return;
    }

    emit(state.copyWith(
      status: SearchStatus.loading,
      query: event.query,
    ));

    final result = await searchCharacters(
      SearchCharactersParams(name: event.query, page: 1),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: failure.message,
      )),
      (characters) {
        if (characters.isEmpty) {
          emit(state.copyWith(
            status: SearchStatus.empty,
            characters: [],
          ));
        } else {
          emit(state.copyWith(
            status: SearchStatus.loaded,
            characters: characters,
            currentPage: 1,
            hasReachedMax: characters.length < 20,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasReachedMax || state.status == SearchStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: SearchStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await searchCharacters(
      SearchCharactersParams(name: state.query, page: nextPage),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: SearchStatus.loaded,
        hasReachedMax: true,
      )),
      (characters) => emit(state.copyWith(
        status: SearchStatus.loaded,
        characters: [...state.characters, ...characters],
        currentPage: nextPage,
        hasReachedMax: characters.length < 20,
      )),
    );
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchState.initial());
  }
}
