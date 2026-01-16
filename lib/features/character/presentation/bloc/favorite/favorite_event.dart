import 'package:equatable/equatable.dart';

import '../../../domain/entities/character.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object? > get props => [];
}

class FetchFavoritesEvent extends FavoriteEvent {
  const FetchFavoritesEvent();
}

class AddFavoriteEvent extends FavoriteEvent {
  final Character character;

  const AddFavoriteEvent({required this.character});

  @override
  List<Object? > get props => [character];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final int characterId;

  const RemoveFavoriteEvent({required this. characterId});

  @override
  List<Object?> get props => [characterId];
}