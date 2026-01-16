import 'package:rick_and_morty_app/features/character/data/models/character_model.dart';
import 'package:rick_and_morty_app/features/character/data/models/character_response_model.dart';
import 'package:rick_and_morty_app/features/character/domain/entities/character.dart';

// Dummy Character Entity
const testCharacter = Character(
  id: 1,
  name:  'Rick Sanchez',
  status: 'Alive',
  species: 'Human',
  type: '',
  gender: 'Male',
  origin: CharacterLocation(
    name: 'Earth (C-137)',
    url: 'https://rickandmortyapi.com/api/location/1',
  ),
  location: CharacterLocation(
    name: 'Citadel of Ricks',
    url: 'https://rickandmortyapi.com/api/location/3',
  ),
  image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
  episode: ['https://rickandmortyapi.com/api/episode/1'],
  url: 'https://rickandmortyapi.com/api/character/1',
  created: '2017-11-04T18:48:46.250Z',
);

const testCharacter2 = Character(
  id: 2,
  name:  'Morty Smith',
  status: 'Alive',
  species: 'Human',
  type: '',
  gender: 'Male',
  origin: CharacterLocation(
    name: 'unknown',
    url: '',
  ),
  location: CharacterLocation(
    name: 'Citadel of Ricks',
    url: 'https://rickandmortyapi.com/api/location/3',
  ),
  image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
  episode: ['https://rickandmortyapi.com/api/episode/1'],
  url: 'https://rickandmortyapi.com/api/character/2',
  created: '2017-11-04T18:50:21.651Z',
);

// Dummy Character Model
const testCharacterModel = CharacterModel(
  id: 1,
  name: 'Rick Sanchez',
  status: 'Alive',
  species:  'Human',
  type:  '',
  gender: 'Male',
  origin: CharacterLocationModel(
    name: 'Earth (C-137)',
    url: 'https://rickandmortyapi.com/api/location/1',
  ),
  location: CharacterLocationModel(
    name: 'Citadel of Ricks',
    url: 'https://rickandmortyapi.com/api/location/3',
  ),
  image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
  episode: ['https://rickandmortyapi.com/api/episode/1'],
  url: 'https://rickandmortyapi.com/api/character/1',
  created: '2017-11-04T18:48:46.250Z',
);

// Dummy Character List
const testCharacterList = [testCharacter, testCharacter2];
const testCharacterModelList = [testCharacterModel];

// Dummy Response Model
const testCharacterResponseModel = CharacterResponseModel(
  info: CharacterInfoModel(
    count: 826,
    pages: 42,
    next: 'https://rickandmortyapi.com/api/character? page=2',
    prev:  null,
  ),
  results: [testCharacterModel],
);

// Dummy JSON Response
final testCharacterJson = {
  'id': 1,
  'name': 'Rick Sanchez',
  'status': 'Alive',
  'species': 'Human',
  'type':  '',
  'gender': 'Male',
  'origin': {
    'name': 'Earth (C-137)',
    'url': 'https://rickandmortyapi.com/api/location/1',
  },
  'location': {
    'name': 'Citadel of Ricks',
    'url': 'https://rickandmortyapi.com/api/location/3',
  },
  'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
  'episode': ['https://rickandmortyapi.com/api/episode/1'],
  'url': 'https://rickandmortyapi.com/api/character/1',
  'created': '2017-11-04T18:48:46.250Z',
};

final testCharacterResponseJson = {
  'info': {
    'count': 826,
    'pages': 42,
    'next': 'https://rickandmortyapi.com/api/character?page=2',
    'prev': null,
  },
  'results': [testCharacterJson],
};