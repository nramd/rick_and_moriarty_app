import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors (Rick and Morty Theme)
  static const Color primaryGreen = Color(0xFF97CE4C);    // Portal Green
  static const Color primaryDark = Color(0xFF44281D);     // Dark Brown
  static const Color accentCyan = Color(0xFF00B5CC);      // Cyan Blue

  // Background Colors
  static const Color backgroundDark = Color(0xFF1D1D1D);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  
  // Surface Colors
  static const Color surfaceDark = Color(0xFF2D2D2D);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  // Card Colors
  static const Color cardDark = Color(0xFF3D3D3D);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textSecondaryLight = Color(0xFF757575);

  // Status Colors
  static const Color alive = Color(0xFF55CC44);           // Green
  static const Color dead = Color(0xFFD63D2E);            // Red
  static const Color unknown = Color(0xFF9E9E9E);         // Grey

  // Utility Colors
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // Gradient Colors
  static const LinearGradient portalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF97CE4C),
      Color(0xFF00B5CC),
    ],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment. topCenter,
    end: Alignment. bottomCenter,
    colors: [
      Color(0xFF2D2D2D),
      Color(0xFF1D1D1D),
    ],
  );
}