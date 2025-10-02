import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1A4E8A),
      onPrimary: Colors.white,
      secondary: Color(0xFF5A7D9A),
      onSecondary: Colors.white,
      tertiary: Color(0xFFF5A623),
      onTertiary: Colors.white,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: Color(0xFFF5F5F5),
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
