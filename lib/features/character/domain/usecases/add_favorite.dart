import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

/// Use case for adding character to favorites
class AddFavorite implements UseCase<void, AddFavoriteParams> {
  final CharacterRepository repository;

  AddFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(AddFavoriteParams params) async {
    return await repository.addFavorite(params.character);
  }
}

/// Parameters for AddFavorite use case
class AddFavoriteParams extends Equatable {
  final Character character;

  const AddFavoriteParams({required this.character});

  @override
  List<Object?> get props => [character];
}
