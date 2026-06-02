import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/gradient_background.dart';
import '../widgets/play_button.dart';
import '../widgets/show_artwork.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  PodcastEpisode? _selectedEpisode;

  bool get _isRecorded => _selectedEpisode != null;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF07030D), Color(0xFF15082B), Color(0xFF06020A)],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SafeArea(
                bottom: false,
                child: _TopPlayer(
                  maxHeight: constraints.maxHeight,
                  isRecorded: _isRecorded,
                  episode: _selectedEpisode,
                  onShare: () => _toast(context, 'Share link copied'),
                  onGoLive: () => setState(() => _selectedEpisode = null),
                ),
              ),
              DraggableScrollableSheet(
                // Starts higher so the sheet fills the empty middle area.
                initialChildSize: .46,
                minChildSize: .34,
                maxChildSize: .985,
                snap: true,
                snapSizes: const [.46, .70, .985],
                builder: (context, controller) {
                  return _DiscoverySheet(
                    controller: controller,
                    onEpisodeSelected: (episode) {
                      setState(() => _selectedEpisode = episode);
                      _toast(context, 'Now playing ${episode.title}');
                    },
                    onGoLive: () => setState(() => _selectedEpisode = null),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _TopPlayer extends StatelessWidget {
  const _TopPlayer({
    required this.maxHeight,
    required this.isRecorded,
    required this.episode,
    required this.onShare,
    required this.onGoLive,
  });

  final double maxHeight;
  final bool isRecorded;
  final PodcastEpisode? episode;
  final VoidCallback onShare;
  final VoidCallback onGoLive;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final artworkHeight = math.min(width - 50, maxHeight * .33).clamp(220.0, 300.0).toDouble();
    final topGap = maxHeight < 760 ? 6.0 : 8.0;
    final title = isRecorded ? episode!.title : currentShow.title;
    final speaker = isRecorded ? episode!.host : currentShow.host;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusDot(label: isRecorded ? 'Recorded' : 'Live', isRecorded: isRecorded),
              const Spacer(),
              _RoundActionButton(icon: Icons.ios_share_rounded, label: 'share', onTap: onShare),
            ],
          ),
          SizedBox(height: topGap),
          SizedBox(
            height: artworkHeight,
            child: ShowArtwork(
              borderRadius: 34,
              showPlayerButton: true,
              icon: isRecorded ? Icons.mic_external_on_rounded : Icons.radio_rounded,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: -.75,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isRecorded ? speaker : 'Speaker 1 & Speaker 2 · ${speaker}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.muted, fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              if (isRecorded)
                TextButton.icon(
                  onPressed: onGoLive,
                  icon: const Icon(Icons.circle, size: 10, color: AppColors.orange),
                  label: const Text('Go live'),
                ),
            ],
          ),
          SizedBox(height: maxHeight < 760 ? 4 : 6),
          if (isRecorded)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: const LinearProgressIndicator(
                  value: .36,
                  minHeight: 5,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.075),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Icon(icon, color: Colors.white.withOpacity(.78), size: 30),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.label, required this.isRecorded});

  final String label;
  final bool isRecorded;

  @override
  Widget build(BuildContext context) {
    final color = isRecorded ? const Color(0xFF23F43F) : const Color(0xFFFF2A2A);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(.42), blurRadius: 20)],
            ),
          ),
          const SizedBox(width: 9),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.10),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 15),
            const SizedBox(height: 1),
            Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _DiscoverySheet extends StatefulWidget {
  const _DiscoverySheet({
    required this.controller,
    required this.onEpisodeSelected,
    required this.onGoLive,
  });

  final ScrollController controller;
  final ValueChanged<PodcastEpisode> onEpisodeSelected;
  final VoidCallback onGoLive;

  @override
  State<_DiscoverySheet> createState() => _DiscoverySheetState();
}

class _DiscoverySheetState extends State<_DiscoverySheet> {
  int _tab = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE8180E26),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Colors.white.withOpacity(.075)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.55),
            blurRadius: 34,
            offset: const Offset(0, -18),
          ),
          BoxShadow(
            color: AppColors.purple.withOpacity(.16),
            blurRadius: 26,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: CustomScrollView(
        controller: widget.controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 7),
                Container(
                  width: 46,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.30),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                _SearchRow(onSearch: () => _showSearchSheet(context)),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedTabsHeader(
              selectedIndex: _tab,
              onChanged: (value) {
                setState(() => _tab = value);
                if (value == 1) widget.onGoLive();
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          if (_tab == 0) ..._previousContent(),
          if (_tab == 1) ..._upcomingContent(),
          const SliverToBoxAdapter(child: SizedBox(height: 145)),
        ],
      ),
    );
  }

  List<Widget> _previousContent() {
    return [
      SliverToBoxAdapter(
        child: SizedBox(
          height: 166,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: podcasts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return _PreviousTile(
                episode: podcasts[index],
                onTap: () => widget.onEpisodeSelected(podcasts[index]),
              );
            },
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
      const SliverToBoxAdapter(child: _DividerLine()),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) return const _DividerLine(horizontalPadding: 24);
            final itemIndex = index ~/ 2;
            return _EpisodeListTile(
              episode: podcasts[itemIndex],
              primaryAction: 'Play next',
              secondaryAction: 'Save',
              onTap: () => widget.onEpisodeSelected(podcasts[itemIndex]),
            );
          },
          childCount: podcasts.isEmpty ? 0 : podcasts.length * 2 - 1,
        ),
      ),
    ];
  }

  List<Widget> _upcomingContent() {
    final featured = schedule.length > 2 ? schedule[2] : currentShow;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(.12),
                  AppColors.purple.withOpacity(.18),
                  AppColors.orange.withOpacity(.12),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white.withOpacity(.10)),
              boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(.14), blurRadius: 26, offset: const Offset(0, 12))],
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(.28), blurRadius: 18, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.schedule_rounded, size: 34),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Next on SUN4U', style: TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: .35)),
                      const SizedBox(height: 6),
                      Text(featured.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -.35)),
                      const SizedBox(height: 4),
                      Text('${featured.time} · ${featured.host}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Container(
                            width: index == 0 ? 18 : 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: index == 0 ? AppColors.orange : Colors.white.withOpacity(.28),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
      const SliverToBoxAdapter(child: _DividerLine()),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) return const _DividerLine(horizontalPadding: 24);
            final itemIndex = index ~/ 2;
            final show = schedule[itemIndex + 2];
            return _UpcomingListTile(
              show: show,
              onReminder: () => _toast(context, 'Reminder set for ${show.title}'),
            );
          },
          childCount: math.max(0, schedule.length - 2) == 0 ? 0 : math.max(0, schedule.length - 2) * 2 - 1,
        ),
      ),
    ];
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SearchBottomSheet(),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _FilterBottomSheet(),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PinnedTabsHeader extends SliverPersistentHeaderDelegate {
  const _PinnedTabsHeader({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(shrinkOffset > 0 ? 0 : 28),
        topRight: Radius.circular(shrinkOffset > 0 ? 0 : 28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xE51A1028),
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(overlapsContent ? .12 : .04))),
            boxShadow: overlapsContent
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(.30),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: _SheetTabs(selectedIndex: selectedIndex, onChanged: onChanged),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedTabsHeader oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.onChanged != onChanged;
  }
}

class _SheetTabs extends StatelessWidget {
  const _SheetTabs({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const labels = ['Previous', 'Upcoming'];
  static const icons = [Icons.history_rounded, Icons.event_note_rounded];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 36,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.055),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final selected = selectedIndex == index;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: selected ? Colors.white.withOpacity(.18) : Colors.transparent,
                    border: Border.all(
                      color: selected ? Colors.white.withOpacity(.16) : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[index], size: 14, color: selected ? Colors.white : AppColors.muted),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          labels[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.muted,
                            fontSize: 10.8,
                            fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
                            letterSpacing: -.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _PreviousTile extends StatelessWidget {
  const _PreviousTile({required this.episode, required this.onTap});

  final PodcastEpisode episode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: SizedBox(
        width: 132,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 128,
              decoration: BoxDecoration(
                gradient: episode.category == 'Research' ? AppColors.tealGradient : AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(.10)),
              ),
              child: Center(child: Icon(_iconForCategory(episode.category), size: 38)),
            ),
            const SizedBox(height: 8),
            Text(
              episode.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onSearch,
        child: Container(
          height: 48,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.18),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(.09)),
          ),
          child: Row(
            children: const [
              Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search shows or topics',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.muted, fontSize: 13.5, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.tune_rounded, color: AppColors.dim, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBottomSheet extends StatelessWidget {
  const _SearchBottomSheet();

  @override
  Widget build(BuildContext context) {
    return _SheetModal(
      title: 'Search SUN4U',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search podcast, speaker, topic...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Popular searches', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _SuggestionChip(label: 'Campus events'),
              _SuggestionChip(label: 'Research stories'),
              _SuggestionChip(label: 'Music'),
              _SuggestionChip(label: 'Student voices'),
              _SuggestionChip(label: 'Wellness'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    return _SheetModal(
      title: 'Filter content',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _SuggestionChip(label: 'All'),
              _SuggestionChip(label: 'Podcast'),
              _SuggestionChip(label: 'Live Show'),
              _SuggestionChip(label: 'Music'),
              _SuggestionChip(label: 'Interviews'),
              _SuggestionChip(label: 'Events'),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Sort by', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _SuggestionChip(label: 'Latest'),
              _SuggestionChip(label: 'Upcoming first'),
              _SuggestionChip(label: 'Most saved'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Apply filter'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetModal extends StatelessWidget {
  const _SheetModal({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1028),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: Colors.white.withOpacity(.10)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.45), blurRadius: 28)],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 26,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -.3),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label selected'))),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({this.horizontalPadding = 24});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Divider(height: 1, color: Colors.white.withOpacity(.14)),
    );
  }
}

class _UpcomingListTile extends StatelessWidget {
  const _UpcomingListTile({required this.show, required this.onReminder});

  final RadioShow show;
  final VoidCallback onReminder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              gradient: show.isLive ? AppColors.orangeGradient : AppColors.purpleGradient,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.08)),
            ),
            child: const Icon(Icons.radio_rounded),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(show.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('By ${show.host}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text(show.time, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SmallAction(label: 'set\nreminder', onTap: onReminder),
          const SizedBox(width: 8),
          _SmallAction(label: 'share', onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shared ${show.title}')))),
        ],
      ),
    );
  }
}

class _EpisodeListTile extends StatelessWidget {
  const _EpisodeListTile({
    required this.episode,
    required this.primaryAction,
    required this.secondaryAction,
    required this.onTap,
  });

  final PodcastEpisode episode;
  final String primaryAction;
  final String secondaryAction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              gradient: episode.category == 'Research' ? AppColors.tealGradient : AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.08)),
            ),
            child: Icon(_iconForCategory(episode.category), size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(episode.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('By ${episode.host}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text('Mon, 18 May 2026 · ${episode.duration}', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SmallAction(label: primaryAction, onTap: onTap),
          const SizedBox(width: 8),
          _SmallAction(label: secondaryAction, onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved ${episode.title}')))),
          const SizedBox(width: 8),
          _SmallAction(label: 'share', onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shared ${episode.title}')))),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.075),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.09)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_actionIcon(label), size: 15, color: Colors.white.withOpacity(.92)),
            const SizedBox(height: 1),
            Text(
              _shortActionLabel(label),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 7.2, fontWeight: FontWeight.w900, height: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _actionIcon(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('reminder')) return Icons.notifications_active_rounded;
  if (lower.contains('share')) return Icons.ios_share_rounded;
  if (lower.contains('save')) return Icons.bookmark_rounded;
  if (lower.contains('play')) return Icons.play_arrow_rounded;
  return Icons.more_horiz_rounded;
}

String _shortActionLabel(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('reminder')) return 'Alert';
  if (lower.contains('share')) return 'Share';
  if (lower.contains('save')) return 'Save';
  if (lower.contains('play')) return 'Play';
  return label.replaceAll('\n', ' ');
}

IconData _iconForCategory(String category) {
  switch (category) {
    case 'Research':
      return Icons.science_rounded;
    case 'Wellness':
      return Icons.spa_rounded;
    case 'Interviews':
      return Icons.record_voice_over_rounded;
    case 'Spoken Word':
      return Icons.mic_external_on_rounded;
    default:
      return Icons.podcasts_rounded;
  }
}
