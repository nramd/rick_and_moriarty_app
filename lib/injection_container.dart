import 'package:get_it/get_it.dart';

import 'core/database/database_helper.dart';
import 'core/network/api_client.dart';
import 'features/character/data/datasources/character_local_datasource.dart';
import 'features/character/data/datasources/character_remote_datasource.dart';
import 'features/character/data/repositories/character_repository_impl.dart';
import 'features/character/domain/repositories/character_repository.dart';
import 'features/character/domain/usecases/usecases.dart';
import 'features/character/presentation/bloc/character/character_bloc.dart';
import 'features/character/presentation/bloc/favorite/favorite_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //!  Core
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  //! Features - Character

  // Data Sources
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CharacterLocalDataSource>(
    () => CharacterLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Repository
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCharacters(sl()));
  sl.registerLazySingleton(() => GetCharacterDetail(sl()));
  sl.registerLazySingleton(() => SearchCharacters(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddFavorite(sl()));
  sl.registerLazySingleton(() => RemoveFavorite(sl()));
  sl.registerLazySingleton(() => CheckFavorite(sl()));
  sl.registerLazySingleton(() => GetPaginationInfo(sl()));

  // BLoC
  sl.registerFactory(
    () => CharacterBloc(getCharacters: sl()),
  );
  sl.registerFactory(
    () => FavoriteBloc(
      getFavorites: sl(),
      addFavorite: sl(),
      removeFavorite: sl(),
    ),
  );
}
