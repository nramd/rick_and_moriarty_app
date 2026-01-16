import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/character_repository.dart';

/// Use case for removing character from favorites
class RemoveFavorite implements UseCase<void, RemoveFavoriteParams> {
  final CharacterRepository repository;

  RemoveFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) async {
    return await repository.removeFavorite(params.characterId);
  }
}

/// Parameters for RemoveFavorite use case
class RemoveFavoriteParams extends Equatable {
  final int characterId;

  const RemoveFavoriteParams({required this.characterId});

  @override
  List<Object?> get props => [characterId];
}