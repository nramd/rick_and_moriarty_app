class AppConstants {
  AppConstants._();

  static const String appName = 'Rick and Morty';
  
  // Database
  static const String databaseName = 'rick_and_morty.db';
  static const int databaseVersion = 1;
  
  // Tables
  static const String favoriteTable = 'favorites';
  
  // Pagination
  static const int pageSize = 20;
  
  // Status
  static const String statusAlive = 'Alive';
  static const String statusDead = 'Dead';
  static const String statusUnknown = 'unknown';
}