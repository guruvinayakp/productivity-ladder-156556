import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AppColors {
  /// Primary color: #6E44FF
  static const Color primary = Color(0xFF6E44FF);

  /// Secondary color: #D7263D
  static const Color secondary = Color(0xFFD7263D);

  /// Accent color: #FFD166
  static const Color accent = Color(0xFFFFD166);

  static const Color background = Color(0xFFF7F6FB);
  static const Color tileLight = Color(0xFFF2ECFF);
  static const Color tileDark = Color(0xFFE6DFFF);
}

/// PUBLIC_INTERFACE
/// Creates the overall Material Theme using the specified project palette.
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    error: Colors.red.shade700,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
    tertiary: AppColors.accent,
    onTertiary: Colors.black87,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      centerTitle: true,
      elevation: 2,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.secondary,
      foregroundColor: colorScheme.onSecondary,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontWeight: FontWeight.bold),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.secondary,
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withOpacity(0.1),
    ),
  );
}
