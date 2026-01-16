import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// [Type] is the return type of the use case
/// [Params] is the parameter type required by the use case
abstract class UseCase<ResultType, Params> {
  Future<Either<Failure, ResultType>> call(Params params);
}

/// Use this class when the use case doesn't require any parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
