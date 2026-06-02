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
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        brightness: Brightness.dark,
        primary: AppColors.purple,
        secondary: AppColors.orange,
        surface: AppColors.panel,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.4),
        displayMedium: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.1),
        headlineLarge: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.9),
        headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.7),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.35),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.15),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.35),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.35),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.1),
      ),
      cardTheme: CardThemeData(
        color: AppColors.panel.withOpacity(.92),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -.4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(.075),
        hintStyle: const TextStyle(color: AppColors.dim, fontWeight: FontWeight.w700),
        prefixIconColor: AppColors.muted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide(color: Colors.white.withOpacity(.08))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: AppColors.orange, width: 1.4)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          shape: roundedShape,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withOpacity(.14)),
          shape: roundedShape,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mint,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF171020),
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white.withOpacity(.08),
        selectedColor: AppColors.purple,
        labelStyle: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        side: BorderSide(color: Colors.white.withOpacity(.12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.purple.withOpacity(.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
