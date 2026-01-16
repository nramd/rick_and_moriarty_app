import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

/// Use case for getting all favorite characters
class GetFavorites implements UseCase<List<Character>, NoParams> {
  final CharacterRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<Character>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}
