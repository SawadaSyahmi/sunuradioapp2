import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Figma-inspired SUN4U palette.
  static const bg = Color(0xFF0018A8);
  static const bg2 = Color(0xFF001177);
  static const panel = Color(0xFF021BB8);
  static const panel2 = Color(0xFF001083);
  static const royalBlue = Color(0xFF0019B8);
  static const royalBlue2 = Color(0xFF0012A0);
  static const deepBlue = Color(0xFF000F7A);
  static const orange = Color(0xFFFF7A3D);
  static const orange2 = Color(0xFFFFA066);
  static const peach = Color(0xFFFFC39E);
  static const pink = Color(0xFFE92BBE);
  static const whitePanel = Color(0xFFF7F7F7);
  static const card = Color(0xFFF2F2F2);
  static const text = Color(0xFFFFFFFF);
  static const navyText = Color(0xFF001C9F);
  static const muted = Color(0xFF8B8B8B);
  static const dim = Color(0xFFB8B8B8);
  static const cardBorder = Color(0x1A000000);

  // Legacy aliases used by older screens.
  static const purple = royalBlue;
  static const violet = royalBlue2;
  static const blue = royalBlue;
  static const mint = orange;
  static const green = Color(0xFF31D27C);

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [royalBlue, royalBlue2, deepBlue],
      );

  static LinearGradient get blueGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [royalBlue, royalBlue2, deepBlue],
      );

  static LinearGradient get orangeGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [orange, Color(0xFFFF8749), peach],
      );

  static LinearGradient get purpleGradient => blueGradient;

  static LinearGradient get tealGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [royalBlue, Color(0xFF0F3EFF), deepBlue],
      );
}
