import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/section_header.dart';
import 'episode_detail_screen.dart';
import 'show_detail_screen.dart';

class SavedLibraryScreen extends StatelessWidget {
  const SavedLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Saved library', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -.6)),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGradient,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(.10)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.bookmarks_rounded, size: 30),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('8 saved items', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                          SizedBox(height: 4),
                          Text('Shows and podcasts you want to revisit.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'Saved shows', subtitle: 'Quick access to your favourite live programmes'),
              const SizedBox(height: 12),
              for (final show in schedule.take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FrostedCard(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShowDetailScreen(show: show))),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(gradient: AppColors.orangeGradient, borderRadius: BorderRadius.circular(18)),
                          child: const Icon(Icons.radio_rounded),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(show.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text('${show.time} · ${show.host}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.dim),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              const SectionHeader(title: 'Saved episodes', subtitle: 'Podcast episodes marked for later'),
              const SizedBox(height: 12),
              for (final episode in podcasts.take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FrostedCard(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EpisodeDetailScreen(episode: episode))),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(gradient: AppColors.tealGradient, borderRadius: BorderRadius.circular(18)),
                          child: const Icon(Icons.podcasts_rounded),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(episode.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text('${episode.category} · ${episode.duration}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.dim),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
