import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/app_logo.dart';
import '../widgets/figma_media.dart';
import '../widgets/play_button.dart';
import 'video_player_screen.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  PodcastEpisode? _selectedEpisode;

  @override
  Widget build(BuildContext context) {
    if (_selectedEpisode != null) {
      return _ProgramDetailPage(
        episode: _selectedEpisode!,
        onBack: () => setState(() => _selectedEpisode = null),
      );
    }

    return _LandingHome(
      onEpisodeSelected: (episode) => setState(() => _selectedEpisode = episode),
      onLiveSelected: () => setState(() => _selectedEpisode = _liveEpisode()),
    );
  }

  PodcastEpisode _liveEpisode() {
    return PodcastEpisode(
      title: currentShow.title,
      host: currentShow.host,
      date: currentShow.date,
      time: currentShow.time,
      duration: currentShow.time,
      category: 'Live',
      description: currentShow.description,
      imageUrl: currentShow.imageUrl,
      heroImageUrl: currentShow.heroImageUrl,
      audioUrl: currentShow.audioUrl,
      videoUrl: currentShow.videoUrl,
      isLive: true,
      seriesName: currentShow.seriesName,
      status: 'live',
      startAt: currentShow.startAt,
      endAt: currentShow.endAt,
    );
  }
}

class _LandingHome extends StatefulWidget {
  const _LandingHome({required this.onEpisodeSelected, required this.onLiveSelected});

  final ValueChanged<PodcastEpisode> onEpisodeSelected;
  final VoidCallback onLiveSelected;

  @override
  State<_LandingHome> createState() => _LandingHomeState();
}

class _LandingHomeState extends State<_LandingHome> {
  int _tab = 1;
  String _query = '';
  String? _category;
  DateTimeRange? _range;

  PodcastEpisode? get _featuredEpisode {
    if (podcasts.isEmpty) return null;
    for (final episode in podcasts) {
      if (episode.isFeatured) return episode;
    }
    return podcasts.first;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = math.min(size.height * .37, 335.0);
    final featured = _featuredEpisode;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: heroHeight,
            child: _HeroProgram(
              episode: featured,
              onTap: featured == null ? widget.onLiveSelected : () => widget.onEpisodeSelected(featured),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: heroHeight,
            bottom: 0,
            child: _CurrentLiveCard(onTap: widget.onLiveSelected),
          ),
          DraggableScrollableSheet(
            initialChildSize: .35,
            minChildSize: .30,
            maxChildSize: .88,
            snap: true,
            snapSizes: const [.35, .88],
            builder: (context, controller) {
              return _ProgramListingSheet(
                scrollController: controller,
                tab: _tab,
                query: _query,
                category: _category,
                range: _range,
                onTabChanged: (value) => setState(() => _tab = value),
                onQueryChanged: (value) => setState(() => _query = value),
                onFilter: _openFilter,
                onEpisodeSelected: widget.onEpisodeSelected,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openFilter() async {
    final result = await showModalBottomSheet<_ProgramFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProgramFilterSheet(
        initialCategory: _category,
        initialRange: _range,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _category = result.category;
      _range = result.range;
    });
  }
}

class _HeroProgram extends StatelessWidget {
  const _HeroProgram({required this.episode, required this.onTap});

  final PodcastEpisode? episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = episode?.title ?? currentShow.title;
    final dateTime = episode?.displayDateTime ?? currentShow.displayDateTime;
    final artwork = episode?.artworkUrl ?? currentShow.artworkUrl;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FigmaMedia(
            imageUrl: artwork,
            title: title,
            category: episode?.category ?? currentShow.category,
            icon: Icons.radio_rounded,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(.05), AppColors.royalBlue.withOpacity(.92)],
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: MediaQuery.paddingOf(context).top + 17,
            child: const AppLogo(compact: true),
          ),
          Positioned(
            left: 40,
            right: 66,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.3,
                  ),
                ),
                const SizedBox(height: 7),
                Text(dateTime, style: const TextStyle(color: Colors.white, fontSize: 11)),
              ],
            ),
          ),
          Positioned(
            right: 28,
            bottom: 34,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.16), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 37),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentLiveCard extends StatelessWidget {
  const _CurrentLiveCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 135,
                height: 176,
                child: FigmaMedia(
                  imageUrl: currentShow.imageUrl,
                  title: currentShow.title,
                  category: 'Live radio',
                  icon: Icons.mic_external_on_rounded,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentShow.displayDateTime,
                      style: const TextStyle(color: AppColors.royalBlue, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentShow.title,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navyText,
                        fontSize: 22,
                        height: .98,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                            decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(6)),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                                SizedBox(width: 4),
                                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const PlayButton(size: 39),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramListingSheet extends StatelessWidget {
  const _ProgramListingSheet({
    required this.scrollController,
    required this.tab,
    required this.query,
    required this.category,
    required this.range,
    required this.onTabChanged,
    required this.onQueryChanged,
    required this.onFilter,
    required this.onEpisodeSelected,
  });

  final ScrollController scrollController;
  final int tab;
  final String query;
  final String? category;
  final DateTimeRange? range;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilter;
  final ValueChanged<PodcastEpisode> onEpisodeSelected;

  @override
  Widget build(BuildContext context) {
    final list = _filteredEpisodes();
    final featured = _featuredForBanner();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ListView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
            ),
          ),
          const SizedBox(height: 14),
          if (featured != null) ...[
            _FeaturedProgramCard(episode: featured, onTap: () => onEpisodeSelected(featured)),
            const SizedBox(height: 9),
            const _DotsIndicator(),
            const SizedBox(height: 14),
          ],
          _ProgramTabs(selected: tab, onChanged: onTabChanged),
          const SizedBox(height: 14),
          _SearchRow(onQueryChanged: onQueryChanged, onFilter: onFilter),
          if (category != null || range != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                if (category != null) _FilterChipLabel(label: category!),
                if (range != null) _FilterChipLabel(label: '${_shortDate(range!.start)} – ${_shortDate(range!.end)}'),
              ],
            ),
          ],
          const SizedBox(height: 18),
          if (list.isEmpty)
            const _EmptyState(label: 'No programs match this filter.')
          else
            for (final episode in list)
              _ProgramRow(
                episode: episode,
                onTap: () => onEpisodeSelected(episode),
              ),
        ],
      ),
    );
  }

  PodcastEpisode? _featuredForBanner() {
    final source = _programsForListing();
    if (source.isEmpty) return null;
    for (final episode in source) {
      if (episode.isFeatured) return episode;
    }
    return source.first;
  }

  List<PodcastEpisode> _filteredEpisodes() {
    final status = tab == 0 ? 'passed' : 'upcoming';
    final lowerQuery = query.trim().toLowerCase();
    return _programsForListing().where((episode) {
      if (episode.effectiveStatus != status && !(tab == 0 && episode.effectiveStatus == 'live')) return false;
      if (category != null && episode.category.toLowerCase() != category!.toLowerCase()) return false;
      if (lowerQuery.isNotEmpty) {
        final haystack = '${episode.title} ${episode.host} ${episode.category} ${episode.seriesName}'.toLowerCase();
        if (!haystack.contains(lowerQuery)) return false;
      }
      if (range != null && episode.startAt != null) {
        final date = DateTime(episode.startAt!.year, episode.startAt!.month, episode.startAt!.day);
        final start = DateTime(range!.start.year, range!.start.month, range!.start.day);
        final end = DateTime(range!.end.year, range!.end.month, range!.end.day, 23, 59, 59);
        if (date.isBefore(start) || date.isAfter(end)) return false;
      }
      return true;
    }).toList();
  }
}

class _FeaturedProgramCard extends StatelessWidget {
  const _FeaturedProgramCard({required this.episode, required this.onTap});

  final PodcastEpisode episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 188,
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (episode.artworkUrl.isNotEmpty)
              FigmaMedia(
                imageUrl: episode.artworkUrl,
                title: episode.title,
                category: episode.category,
                icon: Icons.podcasts_rounded,
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.black.withOpacity(.94), Colors.black.withOpacity(.46), AppColors.royalBlue.withOpacity(.22)],
                ),
              ),
            ),
            Positioned(
              left: 25,
              top: 23,
              right: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(episode.displayDateTime, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  const SizedBox(height: 8),
                  Text(
                    episode.title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 22, height: 1.0, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'with ${episode.host}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramTabs extends StatelessWidget {
  const _ProgramTabs({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Previous', 'Upcoming'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(labels.length, (index) {
        final active = selected == index;
        return InkWell(
          onTap: () => onChanged(index),
          child: Container(
            width: 110,
            padding: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: active ? Colors.white : Colors.transparent, width: 2)),
            ),
            child: Text(
              labels[index],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: active ? FontWeight.w900 : FontWeight.w500),
            ),
          ),
        );
      }),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.onQueryChanged, required this.onFilter});

  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onQueryChanged,
            style: const TextStyle(color: AppColors.navyText, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Search',
              suffixIcon: Icon(Icons.search_rounded),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: onFilter,
            icon: const Icon(Icons.tune_rounded, color: AppColors.orange),
          ),
        ),
      ],
    );
  }
}

class _ProgramRow extends StatelessWidget {
  const _ProgramRow({required this.episode, required this.onTap});

  final PodcastEpisode episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLive = episode.effectiveStatus == 'live';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isLive ? AppColors.royalBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 92,
              child: Text(
                episode.time.isNotEmpty ? episode.time : episode.duration,
                style: TextStyle(color: isLive ? Colors.white : Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.seriesName.isNotEmpty ? episode.seriesName : episode.category,
                    style: TextStyle(color: isLive ? Colors.white70 : const Color(0xFF7F4937), fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    episode.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: isLive ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (episode.hasVideo) Icon(Icons.play_circle_outline_rounded, color: isLive ? Colors.white : AppColors.royalBlue, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ProgramDetailPage extends StatelessWidget {
  const _ProgramDetailPage({required this.episode, required this.onBack});

  final PodcastEpisode episode;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final status = episode.effectiveStatus;
    final label = status == 'live' ? 'LIVE' : status == 'upcoming' ? 'UPCOMING' : 'ARCHIVE';
    final topHeight = math.min(MediaQuery.sizeOf(context).height * .42, 350.0);

    return Container(
      color: AppColors.royalBlue,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: topHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: episode.hasVideo ? () => _openVideo(context) : null,
                  child: FigmaMedia(
                    imageUrl: episode.artworkUrl,
                    title: episode.title,
                    category: episode.category,
                    icon: Icons.mic_none_rounded,
                    showPlay: episode.hasVideo,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: MediaQuery.paddingOf(context).top + 8,
                  child: IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                ),
                Positioned(
                  right: 18,
                  top: MediaQuery.paddingOf(context).top + 16,
                  child: const AppLogo(compact: true),
                ),
                Positioned(
                  left: 22,
                  bottom: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: label == 'UPCOMING' ? AppColors.orange : AppColors.deepBlue.withOpacity(.9),
                    ),
                    child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(28, 22, 28, 120),
            decoration: BoxDecoration(gradient: AppColors.blueGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(episode.displayDateTime, style: const TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    if (episode.hasVideo)
                      _RoundAction(icon: Icons.play_arrow_rounded, onTap: () => _openVideo(context)),
                    const SizedBox(width: 8),
                    _RoundAction(icon: Icons.share_rounded, onTap: () => _toast(context, 'Share link ready')),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  episode.title,
                  style: const TextStyle(color: Colors.white, fontSize: 25, height: .98, fontWeight: FontWeight.w900),
                ),
                if (episode.seriesName.isNotEmpty) ...[
                  const SizedBox(height: 9),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    color: AppColors.deepBlue,
                    child: Text(episode.seriesName, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
                const SizedBox(height: 18),
                Text(
                  episode.description.isEmpty ? 'More details will be available soon.' : episode.description,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.18),
                ),
                if (episode.host.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text('with ${episode.host}', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openVideo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AdaptiveVideoPlayerScreen(
          title: episode.title,
          subtitle: episode.host,
          videoUrl: episode.videoUrl,
          artworkUrl: episode.artworkUrl,
        ),
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(side: BorderSide(color: AppColors.orange.withOpacity(.95), width: 2)),
      child: IconButton(onPressed: onTap, icon: Icon(icon, color: AppColors.orange, size: 22)),
    );
  }
}

class _ProgramFilterResult {
  const _ProgramFilterResult({this.category, this.range});

  final String? category;
  final DateTimeRange? range;
}

class _ProgramFilterSheet extends StatefulWidget {
  const _ProgramFilterSheet({required this.initialCategory, required this.initialRange});

  final String? initialCategory;
  final DateTimeRange? initialRange;

  @override
  State<_ProgramFilterSheet> createState() => _ProgramFilterSheetState();
}

class _ProgramFilterSheetState extends State<_ProgramFilterSheet> {
  int _tab = 0;
  String? _category;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _range = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    final categories = _programsForListing().map((e) => e.category).where((e) => e.trim().isNotEmpty).toSet().toList()..sort();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 70, 16, 16),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _FilterTab(label: 'Date Range', active: _tab == 0, onTap: () => setState(() => _tab = 0)),
                  const SizedBox(width: 26),
                  _FilterTab(label: 'Category', active: _tab == 1, onTap: () => setState(() => _tab = 1)),
                ],
              ),
              const SizedBox(height: 18),
              if (_tab == 0)
                _DateRangePickerCard(
                  range: _range,
                  onChanged: (value) => setState(() => _range = value),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 310),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final item in categories)
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColors.orange,
                          title: Text(item, style: const TextStyle(color: Color(0xFF666666), fontSize: 13)),
                          value: _category == item,
                          onChanged: (_) => setState(() => _category = _category == item ? null : item),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.orange, side: const BorderSide(color: AppColors.orange)),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, _ProgramFilterResult(category: _category, range: _range)),
                      child: const Text('Apply'),
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
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: active ? AppColors.orange : Colors.transparent, width: 2)),
        ),
        child: Text(
          label,
          style: TextStyle(color: active ? AppColors.orange : const Color(0xFFAAAAAA), fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _DateRangePickerCard extends StatelessWidget {
  const _DateRangePickerCard({required this.range, required this.onChanged});

  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(now.year - 2),
              lastDate: DateTime(now.year + 3),
              initialDateRange: range,
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.orange),
                ),
                child: child!,
              ),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.orange),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: AppColors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    range == null ? 'Select start and end date' : '${_shortDate(range!.start)}  →  ${_shortDate(range!.end)}',
                    style: const TextStyle(color: Color(0xFF555555), fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (range != null) ...[
          const SizedBox(height: 8),
          TextButton(onPressed: () => onChanged(null), child: const Text('Clear date range')),
        ],
      ],
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
          width: index == 0 ? 7 : 6,
          height: index == 0 ? 7 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: index == 0 ? AppColors.royalBlue : Colors.white70),
        );
      }),
    );
  }
}

class _FilterChipLabel extends StatelessWidget {
  const _FilterChipLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.92), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(color: AppColors.navyText, fontSize: 10, fontWeight: FontWeight.w700)),
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
      decoration: BoxDecoration(color: Colors.white.withOpacity(.26), borderRadius: BorderRadius.circular(12)),
      child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}


List<PodcastEpisode> _programsForListing() {
  final result = <PodcastEpisode>[...podcasts];
  final keys = result.map((episode) => '${episode.title.toLowerCase()}|${episode.date.toLowerCase()}').toSet();

  for (final show in schedule) {
    final key = '${show.title.toLowerCase()}|${show.date.toLowerCase()}';
    if (keys.contains(key)) continue;
    keys.add(key);
    result.add(
      PodcastEpisode(
        title: show.title,
        host: show.host,
        duration: show.time,
        category: show.category,
        description: show.description,
        date: show.date,
        time: show.time,
        imageUrl: show.imageUrl,
        heroImageUrl: show.heroImageUrl,
        audioUrl: show.audioUrl,
        videoUrl: show.videoUrl,
        isLive: show.isLive,
        seriesName: show.seriesName,
        status: show.effectiveStatus,
        isFeatured: show.isFeatured,
        startAt: show.startAt,
        endAt: show.endAt,
      ),
    );
  }

  return result;
}

String _shortDate(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';

String _month(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[month - 1];
}
