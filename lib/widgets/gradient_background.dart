import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child, this.gradient});

  final Widget child;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient ?? AppColors.backgroundGradient),
      child: SizedBox.expand(child: child),
    );
  }
}
