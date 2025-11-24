import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class AppTheme {
  // =================== LIGHT THEME ===================
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.background,

    primaryColor: const Color.fromARGB(255, 122, 0, 0),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
    ),

    cardColor: AppColors.cardBackground,

    dividerColor: AppColors.separator,

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: Color.fromARGB(255, 122, 0, 0),
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
      elevation: 8,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
      titleLarge: TextStyle(color: AppColors.textPrimary),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 122, 0, 0),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    colorScheme: const ColorScheme.light(
      background: AppColors.background,
      surface: AppColors.surface,
      primary: Color.fromARGB(255, 122, 0, 0),
      secondary: Color.fromARGB(255, 122, 0, 0),
    ).copyWith(surfaceVariant: AppColors.surfaceVariant),
  );

  // =================== DARK THEME ===================
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    primaryColor: Color.fromARGB(255, 122, 0, 0),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
    ),

    cardColor: AppColors.darkCardBackground,

    dividerColor: AppColors.darkSeparator,

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: Color.fromARGB(255, 122, 0, 0),
      unselectedItemColor: AppColors.darkTextSecondary,
      showUnselectedLabels: true,
      elevation: 8,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
      titleLarge: TextStyle(color: AppColors.darkTextPrimary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 122, 0, 0),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    colorScheme: const ColorScheme.dark(
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      primary: Color.fromARGB(255, 122, 0, 0),
      secondary: Color.fromARGB(255, 122, 0, 0),
    ).copyWith(surfaceVariant: AppColors.darkSurfaceVariant),
  );
}