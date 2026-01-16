import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

/// Use case for getting list of characters with pagination
class GetCharacters implements UseCase<List<Character>, GetCharactersParams> {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  @override
  Future<Either<Failure, List<Character>>> call(
      GetCharactersParams params) async {
    return await repository.getCharacters(page: params.page);
  }
}

/// Parameters for GetCharacters use case
class GetCharactersParams extends Equatable {
  final int page;

  const GetCharactersParams({this.page = 1});

  @override
  List<Object?> get props => [page];
}
