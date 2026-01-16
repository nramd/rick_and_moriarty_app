import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/add_favorite.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/remove_favorite.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  FavoriteBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
  }) : super(FavoriteState.initial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onFetchFavorites(
    FetchFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(status: FavoriteStatus.loading));

    final result = await getFavorites(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: FavoriteStatus.error,
        errorMessage: failure.message,
      )),
      (favorites) {
        if (favorites.isEmpty) {
          emit(state.copyWith(
            status: FavoriteStatus.empty,
            favorites: [],
            favoriteIds: {},
          ));
        } else {
          emit(state.copyWith(
            status: FavoriteStatus.loaded,
            favorites: favorites,
            favoriteIds: favorites.map((c) => c.id).toSet(),
          ));
        }
      },
    );
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final result =
        await addFavorite(AddFavoriteParams(character: event.character));

    result.fold(
      (failure) => null,
      (_) {
        final updatedFavorites = [...state.favorites, event.character];
        final updatedIds = {...state.favoriteIds, event.character.id};
        emit(state.copyWith(
          status: FavoriteStatus.loaded,
          favorites: updatedFavorites,
          favoriteIds: updatedIds,
        ));
      },
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await removeFavorite(
        RemoveFavoriteParams(characterId: event.characterId));

    result.fold(
      (failure) => null,
      (_) {
        final updatedFavorites =
            state.favorites.where((c) => c.id != event.characterId).toList();
        final updatedIds = {...state.favoriteIds}..remove(event.characterId);
        emit(state.copyWith(
          status: updatedFavorites.isEmpty
              ? FavoriteStatus.empty
              : FavoriteStatus.loaded,
          favorites: updatedFavorites,
          favoriteIds: updatedIds,
        ));
      },
    );
  }
}
