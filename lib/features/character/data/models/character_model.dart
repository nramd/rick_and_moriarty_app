import '../../domain/entities/character.dart';

/// Character model - data class that can be serialized/deserialized
class CharacterModel extends Character {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.origin,
    required super.location,
    required super.image,
    required super.episode,
    required super.url,
    required super.created,
  });

  /// Create CharacterModel from JSON
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      origin: CharacterLocationModel.fromJson(
          json['origin'] as Map<String, dynamic>),
      location: CharacterLocationModel.fromJson(
          json['location'] as Map<String, dynamic>),
      image: json['image'] as String,
      episode: List<String>.from(json['episode'] as List),
      url: json['url'] as String,
      created: json['created'] as String,
    );
  }

  /// Convert CharacterModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': (origin as CharacterLocationModel).toJson(),
      'location': (location as CharacterLocationModel).toJson(),
      'image': image,
      'episode': episode,
      'url': url,
      'created': created,
    };
  }

  /// Create CharacterModel from Entity
  factory CharacterModel.fromEntity(Character character) {
    return CharacterModel(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      type: character.type,
      gender: character.gender,
      origin: CharacterLocationModel(
        name: character.origin.name,
        url: character.origin.url,
      ),
      location: CharacterLocationModel(
        name: character.location.name,
        url: character.location.url,
      ),
      image: character.image,
      episode: character.episode,
      url: character.url,
      created: character.created,
    );
  }

  /// Create CharacterModel from database map
  factory CharacterModel.fromDatabase(Map<String, dynamic> map) {
    return CharacterModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      type: map['type'] as String,
      gender: map['gender'] as String,
      origin: CharacterLocationModel(
        name: map['origin_name'] as String,
        url: map['origin_url'] as String,
      ),
      location: CharacterLocationModel(
        name: map['location_name'] as String,
        url: map['location_url'] as String,
      ),
      image: map['image'] as String,
      episode: (map['episode'] as String).split(','),
      url: map['url'] as String,
      created: map['created'] as String,
    );
  }

  /// Convert to database map for SQLite storage
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin_name': origin.name,
      'origin_url': origin.url,
      'location_name': location.name,
      'location_url': location.url,
      'image': image,
      'episode': episode.join(','),
      'url': url,
      'created': created,
    };
  }
}

/// Location model for origin and current location
class CharacterLocationModel extends CharacterLocation {
  const CharacterLocationModel({
    required super.name,
    required super.url,
  });

  /// Create from JSON
  factory CharacterLocationModel.fromJson(Map<String, dynamic> json) {
    return CharacterLocationModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
