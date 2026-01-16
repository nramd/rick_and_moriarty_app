/// Exception thrown when there is a server error
class ServerException implements Exception {
  final String?  message;
  final int? statusCode;

  ServerException({this.message, this.statusCode});

  @override
  String toString() {
    return 'ServerException:  $message (Status Code: $statusCode)';
  }
}

/// Exception thrown when there is a cache/database error
class CacheException implements Exception {
  final String? message;

  CacheException({this. message});

  @override
  String toString() {
    return 'CacheException: $message';
  }
}

/// Exception thrown when there is no internet connection
class NetworkException implements Exception {
  final String? message;

  NetworkException({this.message = 'No internet connection'});

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}