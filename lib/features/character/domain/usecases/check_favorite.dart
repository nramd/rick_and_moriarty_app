import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/character_repository.dart';

/// Use case for checking if character is in favorites
class CheckFavorite implements UseCase<bool, CheckFavoriteParams> {
  final CharacterRepository repository;

  CheckFavorite(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckFavoriteParams params) async {
    return await repository.isFavorite(params.characterId);
  }
}

/// Parameters for CheckFavorite use case
class CheckFavoriteParams extends Equatable {
  final int characterId;

  const CheckFavoriteParams({required this.characterId});

  @override
  List<Object?> get props => [characterId];
}
