import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/figma_media.dart';
import '../widgets/gradient_background.dart';
import '../widgets/play_button.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  PodcastEpisode? _selectedEpisode;

  @override
  Widget build(BuildContext context) {
    final selected = _selectedEpisode;
    return GradientBackground(
      child: selected == null
          ? _PodcastHomePage(
              onEpisodeSelected: (episode) => setState(() => _selectedEpisode = episode),
              onLiveSelected: () => setState(() => _selectedEpisode = _liveEpisode()),
            )
          : _PodcastDetailPage(
              episode: selected,
              onBack: () => setState(() => _selectedEpisode = null),
            ),
    );
  }

  PodcastEpisode _liveEpisode() {
    return PodcastEpisode(
      title: currentShow.title,
      host: currentShow.host,
      date: currentShow.date,
      time: currentShow.time,
      duration: currentShow.time,
      category: 'LIVE',
      description: currentShow.description,
      imageUrl: currentShow.imageUrl,
      heroImageUrl: currentShow.heroImageUrl,
      isLive: true,
    );
  }
}

class _PodcastHomePage extends StatefulWidget {
  const _PodcastHomePage({required this.onEpisodeSelected, required this.onLiveSelected});

  final ValueChanged<PodcastEpisode> onEpisodeSelected;
  final VoidCallback onLiveSelected;

  @override
  State<_PodcastHomePage> createState() => _PodcastHomePageState();
}

class _PodcastHomePageState extends State<_PodcastHomePage> {
  int _tab = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = math.min(size.height * .45, 410.0);
    final heroEpisode = podcasts.isNotEmpty ? podcasts.first : null;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: heroHeight,
          child: GestureDetector(
            onTap: heroEpisode == null ? null : () => widget.onEpisodeSelected(heroEpisode),
            child: Stack(
              fit: StackFit.expand,
              children: [
                FigmaMedia(
                  imageUrl: heroEpisode?.artworkUrl ?? currentShow.artworkUrl,
                  title: heroEpisode?.title ?? currentShow.title,
                  category: 'Podcast',
                  icon: Icons.radio_rounded,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.royalBlue.withOpacity(.92)],
                    ),
                  ),
                ),
                Positioned(
                  left: 28,
                  right: 28,
                  bottom: 62,
                  child: _LiveRadioSegment(onOpen: widget.onLiveSelected),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          top: heroHeight - 44,
          child: _OrangeDiscoveryPanel(
            tab: _tab,
            onTabChanged: (value) => setState(() => _tab = value),
            onEpisodeSelected: widget.onEpisodeSelected,
            onLiveSelected: widget.onLiveSelected,
          ),
        ),
      ],
    );
  }
}

class _LiveRadioSegment extends StatelessWidget {
  const _LiveRadioSegment({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Live Radio',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: .2,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onOpen,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(.22), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'ON AIR NOW',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentShow.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'with ${currentShow.host}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.76),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const PlayButton(size: 48),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrangeDiscoveryPanel extends StatelessWidget {
  const _OrangeDiscoveryPanel({
    required this.tab,
    required this.onTabChanged,
    required this.onEpisodeSelected,
    required this.onLiveSelected,
  });

  final int tab;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<PodcastEpisode> onEpisodeSelected;
  final VoidCallback onLiveSelected;

  @override
  Widget build(BuildContext context) {
    final previous = podcasts.where((episode) {
      final category = episode.category.toLowerCase();
      return !category.contains('upcoming');
    }).toList();
    final upcomingShows = schedule.where((show) {
      final category = show.category.toLowerCase();
      return category.contains('upcoming');
    }).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(36, 24, 36, 124),
        children: [
          _Tabs(selectedIndex: tab, onChanged: onTabChanged),
          const SizedBox(height: 14),
          _FeaturedBanner(
            title: 'FILM FUNDING IN MALAYSIA: IS THE SYSTEM WORKING?',
            subtitle: 'with Dato\' Kamil Othman',
          ),
          const SizedBox(height: 10),
          const _DotsIndicator(),
          const SizedBox(height: 18),
          _SearchRow(onFilter: () => _toast(context, 'Filter coming soon')),
          const SizedBox(height: 18),
          if (tab == 0)
            for (final episode in previous)
              _PodcastListCard(
                episode: episode,
                onTap: () => onEpisodeSelected(episode),
              )
          else
            for (final show in upcomingShows)
              _UpcomingShowCard(
                show: show,
                onTap: () => _toast(context, 'Reminder set for ${show.title}'),
              ),
          if (tab == 1 && upcomingShows.isEmpty)
            _EmptyState(label: 'No upcoming sessions yet.'),
          if (tab == 0 && previous.isEmpty)
            _EmptyState(label: 'No recorded podcasts yet.'),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Previous', 'Upcoming'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(labels.length, (index) {
        final selected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onChanged(index),
          child: Container(
            width: 104,
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: selected ? Colors.white : Colors.transparent, width: 2),
              ),
            ),
            child: Text(
              labels[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            right: -24,
            bottom: -26,
            child: CircleAvatar(radius: 72, backgroundColor: AppColors.royalBlue),
          ),
          const Positioned(
            right: 42,
            top: 18,
            child: CircleAvatar(radius: 32, backgroundColor: Color(0xFFBDBDBD), child: Icon(Icons.person, color: Colors.white, size: 42)),
          ),
          Positioned(
            left: 28,
            top: 17,
            right: 112,
            child: Text(
              title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.03, fontWeight: FontWeight.w900, letterSpacing: .3),
            ),
          ),
          Positioned(
            left: 29,
            bottom: 15,
            child: Text(subtitle.toUpperCase(), style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 6, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: index == 0 ? 6 : 5,
          height: index == 0 ? 6 : 5,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0 ? Colors.white : Colors.white.withOpacity(.55),
          ),
        );
      }),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.onFilter});

  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: const [
                Expanded(
                  child: Text('Search', style: TextStyle(color: Color(0xFFC6C6C6), fontSize: 13, fontWeight: FontWeight.w400)),
                ),
                Icon(Icons.search_rounded, color: AppColors.royalBlue, size: 25),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onFilter,
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.tune_rounded, color: AppColors.royalBlue, size: 24),
          ),
        ),
      ],
    );
  }
}

class _PodcastListCard extends StatelessWidget {
  const _PodcastListCard({required this.episode, required this.onTap});

  final PodcastEpisode episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 104,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 104,
              height: 104,
              child: FigmaMedia(
                imageUrl: episode.imageUrl,
                title: episode.title,
                category: episode.category,
                icon: Icons.podcasts_rounded,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(episode.displayDateTime, style: const TextStyle(color: AppColors.royalBlue, fontSize: 8, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 7),
                    Text(
                      episode.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 17, height: .92, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'with ${episode.host}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 8, height: 1.1, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingShowCard extends StatelessWidget {
  const _UpcomingShowCard({required this.show, required this.onTap});

  final RadioShow show;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 104,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 104,
              height: 104,
              child: FigmaMedia(
                imageUrl: show.imageUrl,
                title: show.title,
                category: show.category,
                icon: Icons.radio_rounded,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(show.displayDateTime, style: const TextStyle(color: AppColors.royalBlue, fontSize: 8, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 7),
                    Text(
                      show.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 17, height: .92, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'with ${show.host}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 8, height: 1.1, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.35), borderRadius: BorderRadius.circular(14)),
      child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

class _PodcastDetailPage extends StatelessWidget {
  const _PodcastDetailPage({required this.episode, required this.onBack});

  final PodcastEpisode episode;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topHeight = math.min(MediaQuery.sizeOf(context).height * .43, 355.0);
    final label = episode.isLive || episode.category.toLowerCase().contains('live') ? 'LIVE' : 'PODCAST';

    return Stack(
      children: [
        ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: topHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FigmaMedia(
                    imageUrl: episode.artworkUrl,
                    title: episode.title,
                    category: episode.category,
                    icon: Icons.mic_none_rounded,
                    showPlay: true,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.royalBlue.withOpacity(.94)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: MediaQuery.paddingOf(context).top + 8,
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(height: 5, color: AppColors.orange),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(height: 5, color: Colors.white.withOpacity(.95)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(38, 26, 38, 130),
              decoration: BoxDecoration(gradient: AppColors.blueGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: label == 'LIVE' ? AppColors.orange : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: label == 'LIVE' ? AppColors.orange : Colors.white),
                        ),
                        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
                      ),
                      const Spacer(),
                      _OutlineRoundButton(icon: Icons.add_rounded, onTap: () => _toast(context, 'Added to library')),
                      const SizedBox(width: 12),
                      _OutlineRoundButton(icon: Icons.share_rounded, onTap: () => _toast(context, 'Share link copied')),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    episode.displayDateTime,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    episode.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: .88, letterSpacing: -.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    episode.description,
                    style: const TextStyle(fontSize: 13, height: 1.03, color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _OutlineRoundButton extends StatelessWidget {
  const _OutlineRoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.orange, width: 2),
        ),
        child: Icon(icon, color: AppColors.orange, size: 28),
      ),
    );
  }
}
