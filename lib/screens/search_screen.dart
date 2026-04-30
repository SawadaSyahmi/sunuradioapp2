import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/section_header.dart';
import '../widgets/status_pill.dart';
import 'episode_detail_screen.dart';
import 'event_detail_screen.dart';
import 'now_playing_screen.dart';
import 'show_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final showResults = schedule.where((show) => _matchesShow(show, _query)).toList();
    final episodeResults = podcasts.where((episode) => _matchesEpisode(episode, _query)).toList();
    final eventResults = events.where((event) => _matchesEvent(event, _query)).toList();
    final hasQuery = _query.trim().isNotEmpty;

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
                    child: Text('Search', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -.6)),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search shows, podcasts, hosts, events...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in ['Music', 'Research', 'Talks', 'Events', 'Wellness'])
                    ActionChip(
                      label: Text(tag),
                      onPressed: () => setState(() => _query = tag),
                    ),
                ],
              ),
              const SizedBox(height: 26),
              if (!hasQuery) ...[
                const SectionHeader(title: 'Recommended searches', subtitle: 'Start with what students listen to most'),
                const SizedBox(height: 12),
                _RecommendationCard(
                  title: currentShow.title,
                  subtitle: 'Live now with ${currentShow.host}',
                  icon: Icons.radio_rounded,
                  gradient: AppColors.orangeGradient,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen())),
                ),
                const SizedBox(height: 12),
                _RecommendationCard(
                  title: podcasts.first.title,
                  subtitle: '${podcasts.first.category} · ${podcasts.first.duration}',
                  icon: Icons.podcasts_rounded,
                  gradient: AppColors.purpleGradient,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EpisodeDetailScreen(episode: podcasts.first))),
                ),
                const SizedBox(height: 12),
                _RecommendationCard(
                  title: events.first.title,
                  subtitle: '${events.first.date} · ${events.first.venue}',
                  icon: Icons.event_available_rounded,
                  gradient: AppColors.tealGradient,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(event: events.first))),
                ),
              ] else ...[
                SectionHeader(title: 'Results for “$_query”', subtitle: '${showResults.length + episodeResults.length + eventResults.length} result(s) found'),
                const SizedBox(height: 12),
                if (showResults.isEmpty && episodeResults.isEmpty && eventResults.isEmpty)
                  const _EmptySearchState()
                else ...[
                  if (showResults.isNotEmpty) ...[
                    const _ResultLabel(label: 'Shows'),
                    for (final show in showResults)
                      _ShowResultTile(show: show),
                    const SizedBox(height: 8),
                  ],
                  if (episodeResults.isNotEmpty) ...[
                    const _ResultLabel(label: 'Podcasts'),
                    for (final episode in episodeResults)
                      _EpisodeResultTile(episode: episode),
                    const SizedBox(height: 8),
                  ],
                  if (eventResults.isNotEmpty) ...[
                    const _ResultLabel(label: 'Events'),
                    for (final event in eventResults)
                      _EventResultTile(event: event),
                  ],
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _matchesShow(RadioShow show, String query) {
    if (query.trim().isEmpty) return false;
    final text = '${show.title} ${show.host} ${show.time} ${show.tags.join(' ')}'.toLowerCase();
    return text.contains(query.toLowerCase());
  }

  bool _matchesEpisode(PodcastEpisode episode, String query) {
    if (query.trim().isEmpty) return false;
    final text = '${episode.title} ${episode.host} ${episode.category} ${episode.description}'.toLowerCase();
    return text.contains(query.toLowerCase());
  }

  bool _matchesEvent(CampusEvent event, String query) {
    if (query.trim().isEmpty) return false;
    final text = '${event.title} ${event.date} ${event.venue} ${event.category} ${event.description}'.toLowerCase();
    return text.contains(query.toLowerCase());
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(.10)),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(18)),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                  const SizedBox(height: 4),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _ResultLabel extends StatelessWidget {
  const _ResultLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(label.toUpperCase(), style: const TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: .6)),
    );
  }
}

class _ShowResultTile extends StatelessWidget {
  const _ShowResultTile({required this.show});
  final RadioShow show;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => show.isLive ? const NowPlayingScreen() : ShowDetailScreen(show: show))),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _ResultIcon(icon: Icons.radio_rounded, live: show.isLive),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(show.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900))),
                    if (show.isLive) const LiveBadge(label: 'LIVE'),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${show.host} · ${show.time}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EpisodeResultTile extends StatelessWidget {
  const _EpisodeResultTile({required this.episode});
  final PodcastEpisode episode;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EpisodeDetailScreen(episode: episode))),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const _ResultIcon(icon: Icons.podcasts_rounded),
          const SizedBox(width: 12),
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
        ],
      ),
    );
  }
}

class _EventResultTile extends StatelessWidget {
  const _EventResultTile({required this.event});
  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const _ResultIcon(icon: Icons.event_available_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${event.date} · ${event.venue}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.icon, this.live = false});
  final IconData icon;
  final bool live;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: live ? AppColors.orangeGradient : AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      child: Column(
        children: const [
          Icon(Icons.search_off_rounded, color: AppColors.dim, size: 42),
          SizedBox(height: 12),
          Text('No matching results yet', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          SizedBox(height: 6),
          Text('Try another keyword such as music, research, event, or wellness.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, height: 1.4)),
        ],
      ),
    );
  }
}
