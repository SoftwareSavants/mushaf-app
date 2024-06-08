import 'package:flutter/material.dart';

class ThemeConfig {
  static TextStyle _textStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double? height,
  }) =>
      TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Cairo',
        color: AppColors.onBackground,
        height: height,
      );

  static ThemeData get lightTheme => ThemeData.light().copyWith(
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          background: AppColors.background,
          onBackground: AppColors.onBackground,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.onError,
          outline: AppColors.outline,
          onSurfaceVariant: AppColors.onSurfaceVariant,
        ),
        backgroundColor: AppColors.background,
        errorColor: AppColors.error,
        scaffoldBackgroundColor: AppColors.scaffoldBg,
        textTheme: TextTheme(
          headline4: _textStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.7,
          ),
          headline5: _textStyle(fontSize: 28, fontWeight: FontWeight.w600),
          headline6: _textStyle(fontSize: 20, fontWeight: FontWeight.bold),
          subtitle1: _textStyle(fontSize: 16, fontWeight: FontWeight.bold),
          subtitle2: _textStyle(fontSize: 14, fontWeight: FontWeight.w700),
          bodyText1: _textStyle(fontSize: 16),
          bodyText2: _textStyle(fontSize: 14),
          caption: _textStyle(fontSize: 12),
        ),
        primaryColorLight: AppColors.primary,
        primaryColorDark: AppColors.primary,
        cardTheme: CardTheme(
          elevation: 14,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dividerTheme: const DividerThemeData(
          thickness: .5,
          space: 16,
          color: AppColors.outline,
        ),
      );

  static ThemeData get darkTheme => ThemeData.dark(useMaterial3: true);

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
}

class AppColors {
  static const primary = Color(0xFF287142);
  static const onPrimary = Color(0xFFFFFFFF);

  static const secondary = Color(0xFF07164D);
  static const onSecondary = Color(0xFFFFFFFF);

  static const background = Color(0xFFF8F8F8);
  static const onBackground = Color(0xFF4B4B4B);

  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF2D2D2D);
  static const onSurfaceVariant = Color(0xFF747474);

  static const error = Color(0xFFDA3838);
  static const onError = Color(0xFFFFFFFF);

  static const success = Color(0xFF01D066);

  static const scaffoldBg = Color(0xFFF9FBFA);

  static const outline = Color(0xFFB7B7B7);
}
