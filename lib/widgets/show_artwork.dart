import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'play_button.dart';

class ShowArtwork extends StatelessWidget {
  const ShowArtwork({
    super.key,
    this.height,
    this.icon = Icons.headphones_rounded,
    this.showLogo = true,
    this.showPlayerButton = true,
    this.borderRadius = 32,
  });

  final double? height;
  final IconData icon;
  final bool showLogo;
  final bool showPlayerButton;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF5663), Color(0xFFB03AFF), Color(0xFF235CFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(.30),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = constraints.maxHeight;
          final visualTop = (cardHeight * .22).clamp(46.0, 72.0).toDouble();

          return Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _ArtworkPainter())),
              Positioned(
                left: -22,
                top: -22,
                child: _BlurCircle(size: 160, color: Colors.white.withOpacity(.16)),
              ),
              Positioned(
                right: -30,
                bottom: -35,
                child: _BlurCircle(size: 170, color: AppColors.orange.withOpacity(.24)),
              ),
              Positioned(
                top: visualTop,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(.06),
                      border: Border.all(color: Colors.white.withOpacity(.16), width: 1.4),
                    ),
                    child: Icon(icon, size: 48, color: Colors.white.withOpacity(.90)),
                  ),
                ),
              ),
              if (showLogo)
                Positioned(
                  top: 26,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: .82,
                    child: Column(
                      children: const [
                        Text('SUN4U', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -.6)),
                        SizedBox(height: 2),
                        Text('R A D I O', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, letterSpacing: 4.0, height: .95)),
                      ],
                    ),
                  ),
                ),
              if (showPlayerButton)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 18,
                  child: Center(child: PlayButton(size: 58)),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 70, spreadRadius: 26)],
      ),
    );
  }
}

class _ArtworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(.08)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 5; i++) {
      final path = Path();
      final y = size.height * (.25 + i * .12);
      path.moveTo(-10, y);
      for (double x = -10; x <= size.width + 10; x += 8) {
        final dy = math.sin((x / size.width * math.pi * 2) + i) * (8 + i * 2);
        path.lineTo(x, y + dy);
      }
      canvas.drawPath(path, wavePaint);
    }

    final dotPaint = Paint()..color = Colors.white.withOpacity(.06);
    for (var i = 0; i < 38; i++) {
      final x = ((i * 47) % size.width).toDouble();
      final y = ((i * 31) % size.height).toDouble();
      canvas.drawCircle(Offset(x, y), 1.2 + (i % 3), dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
