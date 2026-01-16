import 'package:equatable/equatable.dart';

import '../../../domain/entities/character.dart';

enum FavoriteStatus { initial, loading, loaded, error, empty }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<Character> favorites;
  final String errorMessage;
  final Set<int> favoriteIds;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.favorites = const [],
    this.errorMessage = '',
    this.favoriteIds = const {},
  });

  factory FavoriteState.initial() => const FavoriteState();

  bool isFavorite(int characterId) => favoriteIds.contains(characterId);

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<Character>? favorites,
    String? errorMessage,
    Set<int>? favoriteIds,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object?> get props => [status, favorites, errorMessage, favoriteIds];
}
