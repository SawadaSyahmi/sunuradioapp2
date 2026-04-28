import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class FrostedCard extends StatelessWidget {
  const FrostedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 28,
    this.color,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(.075),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor ?? AppColors.cardBorder),
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return card;
    return InkWell(borderRadius: BorderRadius.circular(radius), onTap: onTap, child: card);
  }
}
