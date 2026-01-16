import 'package:equatable/equatable.dart';

/// Character entity - represents a character from Rick and Morty
class Character extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterLocation origin;
  final CharacterLocation location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  /// Check if character is alive
  bool get isAlive => status.toLowerCase() == 'alive';

  /// Check if character is dead
  bool get isDead => status.toLowerCase() == 'dead';

  /// Check if character status is unknown
  bool get isUnknown => status.toLowerCase() == 'unknown';

  /// Get episode count
  int get episodeCount => episode.length;

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        origin,
        location,
        image,
        episode,
        url,
        created,
      ];
}

/// Location entity for origin and current location
class CharacterLocation extends Equatable {
  final String name;
  final String url;

  const CharacterLocation({
    required this.name,
    required this.url,
  });

  /// Check if location is unknown
  bool get isUnknown => name.toLowerCase() == 'unknown';

  @override
  List<Object?> get props => [name, url];
}
