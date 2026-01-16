import 'package:equatable/equatable.dart';

import '../../../domain/entities/character.dart';

enum CharacterStatus { initial, loading, loaded, loadingMore, error }

class CharacterState extends Equatable {
  final CharacterStatus status;
  final List<Character> characters;
  final String errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const CharacterState({
    this.status = CharacterStatus.initial,
    this.characters = const [],
    this.errorMessage = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  factory CharacterState.initial() => const CharacterState();

  CharacterState copyWith({
    CharacterStatus? status,
    List<Character>? characters,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return CharacterState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props =>
      [status, characters, errorMessage, currentPage, hasReachedMax];
}
