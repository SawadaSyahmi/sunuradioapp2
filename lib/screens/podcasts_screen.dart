import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/section_header.dart';
import '../widgets/show_artwork.dart';
import '../widgets/status_pill.dart';
import 'episode_detail_screen.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 184),
          children: [
            const Text('Podcasts', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -.8)),
            const SizedBox(height: 6),
            const Text('Campus voices, interviews, research stories, and student-made shows.', style: TextStyle(color: AppColors.muted, height: 1.35)),
            const SizedBox(height: 22),
            _FeaturedPodcast(episode: podcasts.first),
            const SizedBox(height: 22),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search podcasts, hosts, or topics',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: const [
                  _FilterChip(label: 'All', selected: true),
                  _FilterChip(label: 'Interviews'),
                  _FilterChip(label: 'Research'),
                  _FilterChip(label: 'Wellness'),
                  _FilterChip(label: 'Design'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Latest episodes', subtitle: 'Tap an episode to view details'),
            const SizedBox(height: 12),
            for (final episode in podcasts) _EpisodeCard(episode: episode),
          ],
        ),
      ),
    );
  }
}

class _FeaturedPodcast extends StatelessWidget {
  const _FeaturedPodcast({required this.episode});

  final PodcastEpisode episode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EpisodeDetailScreen(episode: episode))),
      child: Container(
        height: 210,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(.10)),
          boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(.22), blurRadius: 28, offset: const Offset(0, 16))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusPill(label: 'FEATURED EPISODE', icon: Icons.auto_awesome_rounded),
                  const Spacer(),
                  Text(episode.title, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: .98, letterSpacing: -.6)),
                  const SizedBox(height: 8),
                  Text('${episode.host} · ${episode.duration}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const SizedBox(
              width: 104,
              height: 142,
              child: ShowArtwork(borderRadius: 28, icon: Icons.mic_external_on_rounded, showLogo: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.mint : Colors.white.withOpacity(.075),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.mint : Colors.white.withOpacity(.09)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.bg : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
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
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: episode.category == 'Research' ? AppColors.tealGradient : AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(_iconForCategory(episode.category), color: Colors.white, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(episode.category.toUpperCase(), style: const TextStyle(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .35)),
                  const SizedBox(height: 5),
                  Text(episode.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, height: 1.15)),
                  const SizedBox(height: 5),
                  Text('${episode.host} · ${episode.duration}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.07), shape: BoxShape.circle),
              child: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Research':
        return Icons.science_rounded;
      case 'Wellness':
        return Icons.spa_rounded;
      case 'Interviews':
        return Icons.record_voice_over_rounded;
      default:
        return Icons.mic_external_on_rounded;
    }
  }
}
