import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/character_repository.dart';

/// Use case for getting pagination info
class GetPaginationInfo
    implements UseCase<PaginationInfo, GetPaginationInfoParams> {
  final CharacterRepository repository;

  GetPaginationInfo(this.repository);

  @override
  Future<Either<Failure, PaginationInfo>> call(
      GetPaginationInfoParams params) async {
    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      return await repository.getSearchPaginationInfo(
        name: params.searchQuery!,
        page: params.page,
      );
    }
    return await repository.getPaginationInfo(page: params.page);
  }
}

/// Parameters for GetPaginationInfo use case
class GetPaginationInfoParams extends Equatable {
  final int page;
  final String? searchQuery;

  const GetPaginationInfoParams({
    this.page = 1,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, searchQuery];
}
