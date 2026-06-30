import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final roundedShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(18));

    final textTheme = base.textTheme.apply(
      fontFamily: 'Inter',
      fontFamilyFallback: const ['Roboto', 'SF Pro Display', 'Arial'],
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.royalBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.royalBlue,
        brightness: Brightness.dark,
        primary: AppColors.royalBlue,
        secondary: AppColors.orange,
        surface: AppColors.royalBlue,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.4),
        displayMedium: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.1),
        headlineLarge: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.9),
        headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.7),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.35),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.15),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.32),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.32),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.1),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.royalBlue,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -.4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppColors.dim, fontWeight: FontWeight.w500),
        prefixIconColor: AppColors.royalBlue,
        suffixIconColor: AppColors.royalBlue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: const BorderSide(color: AppColors.orange, width: 1.4)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          shape: roundedShape,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white54),
          shape: roundedShape,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.orange,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepBlue,
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: AppColors.orange,
        labelStyle: const TextStyle(color: AppColors.navyText, fontWeight: FontWeight.w800),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.orange.withOpacity(.14),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
