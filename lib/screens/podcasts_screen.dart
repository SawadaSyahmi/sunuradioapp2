import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import 'episode_detail_screen.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 170),
          children: [
            const Text('Podcasts', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('Browse campus voices, interviews, and student-made stories.', style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 22),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search podcasts',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white.withOpacity(.08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                Chip(label: Text('All')),
                Chip(label: Text('Interviews')),
                Chip(label: Text('Research')),
                Chip(label: Text('Wellness')),
                Chip(label: Text('Design')),
              ],
            ),
            const SizedBox(height: 20),
            for (final episode in podcasts) _EpisodeCard(episode: episode),
          ],
        ),
      ),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  const _EpisodeCard({required this.episode});

  final PodcastEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FrostedCard(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EpisodeDetailScreen(episode: episode))),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: episode.category == 'Research' ? AppColors.tealGradient : AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.mic_external_on_rounded, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(episode.category.toUpperCase(), style: const TextStyle(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(episode.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('${episode.host} · ${episode.duration}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.dim),
          ],
        ),
      ),
    );
  }
}
