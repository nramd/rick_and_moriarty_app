import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/core/network/api_client.dart';
import 'package:rick_and_morty_app/features/character/data/datasources/character_local_datasource.dart';
import 'package:rick_and_morty_app/features/character/data/datasources/character_remote_datasource.dart';
import 'package:rick_and_morty_app/features/character/domain/repositories/character_repository.dart';
import 'package:rick_and_morty_app/features/character/domain/usecases/get_characters.dart';

// Mock classes
class MockCharacterRepository extends Mock implements CharacterRepository {}

class MockCharacterRemoteDataSource extends Mock implements CharacterRemoteDataSource {}

class MockCharacterLocalDataSource extends Mock implements CharacterLocalDataSource {}

class MockApiClient extends Mock implements ApiClient {}

class MockGetCharacters extends Mock implements GetCharacters {}