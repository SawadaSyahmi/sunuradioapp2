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
      child: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: _Glow(color: AppColors.purple.withOpacity(.42), size: 240),
            ),
            Positioned(
              left: -90,
              bottom: 80,
              child: _Glow(color: AppColors.orange.withOpacity(.28), size: 220),
            ),
            Positioned(
              right: 20,
              bottom: -80,
              child: _Glow(color: AppColors.blue.withOpacity(.22), size: 180),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 45)],
      ),
    );
  }
}
