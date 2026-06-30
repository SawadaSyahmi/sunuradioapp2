import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class FigmaMedia extends StatelessWidget {
  const FigmaMedia({
    super.key,
    this.imageUrl = '',
    required this.title,
    this.category = '',
    this.icon = Icons.mic_none_rounded,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.showPlay = false,
  });

  final String imageUrl;
  final String title;
  final String category;
  final IconData icon;
  final double borderRadius;
  final BoxFit fit;
  final bool showPlay;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;
    final child = hasImage
        ? Image.network(
            imageUrl.trim(),
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => _FallbackPoster(title: title, category: category, icon: icon),
          )
        : _FallbackPoster(title: title, category: category, icon: icon);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (showPlay)
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 44),
              ),
            ),
        ],
      ),
    );
  }
}

class _FallbackPoster extends StatelessWidget {
  const _FallbackPoster({required this.title, required this.category, required this.icon});

  final String title;
  final String category;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isEvent = category.toLowerCase().contains('event') || category.toLowerCase().contains('lecture');
    final isCoffee = title.toLowerCase().contains('coffee');
    final isImpossible = title.toLowerCase().contains('impossible');
    final colors = isEvent
        ? const [Color(0xFFFFD6B9), Color(0xFFE85C38), AppColors.royalBlue]
        : isCoffee
            ? const [Color(0xFFFF9A57), Color(0xFFE3522F), Color(0xFF1A1A1A)]
            : isImpossible
                ? const [Color(0xFF171717), Color(0xFF262626), AppColors.royalBlue]
                : const [Color(0xFF8EC8FF), Color(0xFF2E4FE8), AppColors.deepBlue];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -22,
            child: Icon(icon, size: 122, color: Colors.white.withOpacity(.15)),
          ),
          Positioned(
            left: 16,
            top: 16,
            right: 16,
            child: Text(
              title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
                height: 1.03,
                letterSpacing: -.2,
              ),
            ),
          ),
          if (category.trim().isNotEmpty)
            Positioned(
              left: 16,
              bottom: 14,
              child: Text(
                category.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(.78),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .7,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
