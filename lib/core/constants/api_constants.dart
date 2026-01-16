class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://rickandmortyapi.com/api';
  
  // Endpoints
  static const String character = '/character';
  
  // Timeout durations (in milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}