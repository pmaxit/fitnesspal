import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';

class AppTheme {
  static const double radiusXs = 4;
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 10;
  static const double radiusXl = 12;
  static const double radius2xl = 16;
  static const double radius3xl = 20;

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.accent,
    scaffoldBackgroundColor: AppColors.darkBgApp,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBgApp,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkBgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius2xl),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),
    textTheme: _buildTextTheme(AppColors.darkFg1, AppColors.darkFg2, AppColors.darkFg3),
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.accent,
      unselectedLabelColor: AppColors.darkFg3,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.accent, width: 3),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.darkFg1),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.accent,
    scaffoldBackgroundColor: AppColors.lightBgApp,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBgApp,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightBgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius2xl),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
    ),
    textTheme: _buildTextTheme(AppColors.lightFg1, AppColors.lightFg2, AppColors.lightFg3),
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.accent,
      unselectedLabelColor: AppColors.lightFg3,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.accent, width: 3),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.lightFg1),
  );

  static TextTheme _buildTextTheme(Color primary, Color secondary, Color tertiary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: primary,
        letterSpacing: -0.04,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: -0.04,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.02,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.02,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.02,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: tertiary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: tertiary,
        letterSpacing: 0.1,
      ),
    );
  }
}
