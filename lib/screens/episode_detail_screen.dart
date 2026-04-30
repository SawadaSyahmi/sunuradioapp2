import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/radio_models.dart';
import '../widgets/gradient_background.dart';
import '../widgets/play_button.dart';
import '../widgets/show_artwork.dart';
import '../widgets/status_pill.dart';

class EpisodeDetailScreen extends StatelessWidget {
  const EpisodeDetailScreen({super.key, required this.episode});

  final PodcastEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () => _toast(context, 'Episode options coming soon'),
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const SizedBox(
                height: 282,
                child: ShowArtwork(borderRadius: 38, icon: Icons.podcasts_rounded),
              ),
              const SizedBox(height: 28),
              StatusPill(label: episode.category.toUpperCase(), icon: Icons.auto_awesome_rounded, foregroundColor: AppColors.mint),
              const SizedBox(height: 12),
              Text(episode.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.03, letterSpacing: -.7)),
              const SizedBox(height: 10),
              Text('${episode.host} · ${episode.duration}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              Text(episode.description, style: const TextStyle(color: AppColors.muted, height: 1.55, fontSize: 15)),
              const SizedBox(height: 34),
              Row(
                children: [
                  const PlayButton(size: 66),
                  const SizedBox(width: 14),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _toast(context, 'Episode saved to your library'),
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
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
