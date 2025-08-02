import 'package:flutter/material.dart';

class AppTheme {
  // Color palette
  static const Color primaryColor = Color(0xFF1B3C53);
  static const Color secondaryColor = Color(0xFF456882);
  static const Color accentColor = Color(0xFFD2C1B6);
  static const Color neutralColor = Color(0xFFF9F3EF);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Pixelated',
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: neutralColor,
        surfaceTint: neutralColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Pixelated',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Pixelated',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Pixelated',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontFamily: 'Pixelated',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Pixelated',
          color: secondaryColor,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Pixelated',
          color: Colors.grey,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
      scaffoldBackgroundColor: neutralColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Pixelated'),
        displayMedium: TextStyle(fontFamily: 'Pixelated'),
        displaySmall: TextStyle(fontFamily: 'Pixelated'),
        headlineLarge: TextStyle(fontFamily: 'Pixelated'),
        headlineMedium: TextStyle(fontFamily: 'Pixelated'),
        headlineSmall: TextStyle(fontFamily: 'Pixelated'),
        titleLarge: TextStyle(fontFamily: 'Pixelated'),
        titleMedium: TextStyle(fontFamily: 'Pixelated'),
        titleSmall: TextStyle(fontFamily: 'Pixelated'),
        bodyLarge: TextStyle(fontFamily: 'Pixelated'),
        bodyMedium: TextStyle(fontFamily: 'Pixelated'),
        bodySmall: TextStyle(fontFamily: 'Pixelated'),
        labelLarge: TextStyle(fontFamily: 'Pixelated'),
        labelMedium: TextStyle(fontFamily: 'Pixelated'),
        labelSmall: TextStyle(fontFamily: 'Pixelated'),
      ),
    );
  }
} 