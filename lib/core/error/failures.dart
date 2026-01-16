import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Failure for cache/database-related errors
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure for network-related errors
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Failure for unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unknown error occurred'});
}