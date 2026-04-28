import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 18.0 : 32.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SUN',
          style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          '4',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: size + 2,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          'U',
          style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'RADIO',
          style: TextStyle(
            color: compact ? AppColors.orange : Colors.white,
            fontSize: compact ? 7 : 12,
            fontWeight: FontWeight.w900,
            height: .9,
          ),
        ),
      ],
    );
  }
}
