import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const bg = Color(0xFF07010F);
  static const bg2 = Color(0xFF120826);
  static const panel = Color(0xFF1C1130);
  static const panel2 = Color(0xFF271642);
  static const purple = Color(0xFF7C4DFF);
  static const violet = Color(0xFFB650FF);
  static const orange = Color(0xFFFF6A3D);
  static const orange2 = Color(0xFFFF9C54);
  static const pink = Color(0xFFFF4FA3);
  static const blue = Color(0xFF3B8CFF);
  static const mint = Color(0xFF47F5B5);
  static const green = Color(0xFF31D27C);
  static const text = Color(0xFFFFFFFF);
  static const muted = Color(0xFFB8AFC9);
  static const dim = Color(0xFF746B83);
  static const cardBorder = Color(0x22FFFFFF);

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [bg, bg2, Color(0xFF1A0B35)],
      );

  static LinearGradient get orangeGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [orange, Color(0xFFFF4D5B), purple],
      );

  static LinearGradient get purpleGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5F49FF), purple, Color(0xFF261052)],
      );

  static LinearGradient get tealGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [blue, Color(0xFF5E6BFF), Color(0xFF00846C)],
      );
}
