import 'package:flutter/material.dart';

enum AppLogoVariant { white, colour, black }

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.compact = false,
    this.variant = AppLogoVariant.white,
    this.width,
  });

  final bool compact;
  final AppLogoVariant variant;
  final double? width;

  String get _assetPath {
    switch (variant) {
      case AppLogoVariant.black:
        return 'assets/branding/sun4u_logo_black.png';
      case AppLogoVariant.colour:
        return 'assets/branding/sun4u_logo_colour.png';
      case AppLogoVariant.white:
        return 'assets/branding/sun4u_logo_white.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoWidth = width ?? (compact ? 82.0 : 180.0);

    return Semantics(
      label: 'SUN4U Radio',
      image: true,
      child: Image.asset(
        _assetPath,
        width: logoWidth,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Text(
            'SUN4U RADIO',
            style: TextStyle(
              color: variant == AppLogoVariant.black ? Colors.black : Colors.white,
              fontSize: compact ? 14 : 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -.6,
            ),
          );
        },
      ),
    );
  }
}
