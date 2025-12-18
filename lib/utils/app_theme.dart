import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Color(0xFFFFFAF6),
    fontFamily: 'DM Sans',

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: AppTextStyles.body1Mid,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      hintStyle: AppTextStyles.body1Mid.copyWith(
        color: const Color.fromARGB(144, 26, 26, 26),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1,
      displayMedium: AppTextStyles.heading2,
      displaySmall: AppTextStyles.heading3,
      headlineLarge: AppTextStyles.heading4,
      bodyLarge: AppTextStyles.body1,
      bodyMedium: AppTextStyles.body1Mid,
    ),
  );
}
