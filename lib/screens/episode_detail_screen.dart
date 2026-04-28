import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/radio_models.dart';
import '../widgets/gradient_background.dart';
import '../widgets/play_button.dart';

class EpisodeDetailScreen extends StatelessWidget {
  const EpisodeDetailScreen({super.key, required this.episode});

  final PodcastEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton.filled(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(.08)),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(height: 24),
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: const Icon(Icons.podcasts_rounded, size: 112, color: Colors.white),
                ),
                const SizedBox(height: 28),
                Text(episode.category.toUpperCase(), style: const TextStyle(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(episode.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.05)),
                const SizedBox(height: 10),
                Text('${episode.host} · ${episode.duration}', style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 24),
                Text(episode.description, style: const TextStyle(color: AppColors.muted, height: 1.55)),
                const Spacer(),
                Row(
                  children: [
                    const PlayButton(size: 64),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_add_rounded),
                        label: const Text('Save Episode'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
