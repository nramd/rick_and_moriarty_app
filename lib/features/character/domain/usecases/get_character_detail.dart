import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

/// Use case for getting character detail by ID
class GetCharacterDetail
    implements UseCase<Character, GetCharacterDetailParams> {
  final CharacterRepository repository;

  GetCharacterDetail(this.repository);

  @override
  Future<Either<Failure, Character>> call(
      GetCharacterDetailParams params) async {
    return await repository.getCharacterById(params.id);
  }
}

/// Parameters for GetCharacterDetail use case
class GetCharacterDetailParams extends Equatable {
  final int id;

  const GetCharacterDetailParams({required this.id});

  @override
  List<Object?> get props => [id];
}
