import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import 'live_badge.dart';
import 'play_button.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key, required this.onOpenPlayer});

  final VoidCallback onOpenPlayer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 84),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onOpenPlayer,
          child: Container(
            height: 76,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5522AB), Color(0xFF22123F)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(.12)),
              boxShadow: [
                BoxShadow(color: AppColors.purple.withOpacity(.28), blurRadius: 32, offset: const Offset(0, 18)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: AppColors.orangeGradient,
                  ),
                  child: const Icon(Icons.graphic_eq_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LiveBadge(label: 'LIVE'),
                      const SizedBox(height: 3),
                      Text(
                        currentShow.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      Text(
                        currentShow.host,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const PlayButton(size: 46),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
