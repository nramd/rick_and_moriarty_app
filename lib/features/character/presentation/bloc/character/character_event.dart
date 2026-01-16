import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

class FetchCharactersEvent extends CharacterEvent {
  const FetchCharactersEvent();
}

class LoadMoreCharactersEvent extends CharacterEvent {
  const LoadMoreCharactersEvent();
}

class RefreshCharactersEvent extends CharacterEvent {
  const RefreshCharactersEvent();
}