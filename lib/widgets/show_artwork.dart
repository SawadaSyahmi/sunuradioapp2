import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ShowArtwork extends StatelessWidget {
  const ShowArtwork({
    super.key,
    this.height,
    this.icon = Icons.headphones_rounded,
    this.showLogo = true,
    this.borderRadius = 32,
  });

  final double? height;
  final IconData icon;
  final bool showLogo;
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
      child: Stack(
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
          Center(
            child: Container(
              width: 114,
              height: 114,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(.08),
                border: Border.all(color: Colors.white.withOpacity(.17), width: 1.4),
              ),
              child: Icon(icon, size: 58, color: Colors.white.withOpacity(.90)),
            ),
          ),
          if (showLogo)
            Positioned(
              top: 28,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: .72,
                child: Column(
                  children: const [
                    Text('SUN4U', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: -.5)),
                    Text('RADIO', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, height: .8)),
                  ],
                ),
              ),
            ),
        ],
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
