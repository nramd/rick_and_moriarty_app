import 'package:equatable/equatable.dart';

import '../../../domain/entities/character.dart';

enum SearchStatus { initial, loading, loaded, loadingMore, error, empty }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Character> characters;
  final String errorMessage;
  final String query;
  final int currentPage;
  final bool hasReachedMax;

  const SearchState({
    this.status = SearchStatus.initial,
    this. characters = const [],
    this. errorMessage = '',
    this. query = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  factory SearchState.initial() => const SearchState();

  SearchState copyWith({
    SearchStatus? status,
    List<Character>? characters,
    String? errorMessage,
    String? query,
    int? currentPage,
    bool?  hasReachedMax,
  }) {
    return SearchState(
      status: status ?? this. status,
      characters: characters ??  this.characters,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax:  hasReachedMax ?? this. hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, characters, errorMessage, query, currentPage, hasReachedMax];
}