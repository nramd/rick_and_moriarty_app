import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

/// Use case for searching characters by name
class SearchCharacters
    implements UseCase<List<Character>, SearchCharactersParams> {
  final CharacterRepository repository;

  SearchCharacters(this.repository);

  @override
  Future<Either<Failure, List<Character>>> call(
      SearchCharactersParams params) async {
    return await repository.searchCharacters(
      name: params.name,
      page: params.page,
    );
  }
}

/// Parameters for SearchCharacters use case
class SearchCharactersParams extends Equatable {
  final String name;
  final int page;

  const SearchCharactersParams({
    required this.name,
    this.page = 1,
  });

  @override
  List<Object?> get props => [name, page];
}
