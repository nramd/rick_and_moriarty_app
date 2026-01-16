import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchCharactersEvent extends SearchEvent {
  final String query;

  const SearchCharactersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadMoreSearchResultsEvent extends SearchEvent {
  const LoadMoreSearchResultsEvent();
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}
