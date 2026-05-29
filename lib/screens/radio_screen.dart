import 'dart:math' as math;

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
                initialChildSize: .36,
                minChildSize: .34,
                maxChildSize: .76,
                snap: true,
                snapSizes: const [.36, .76],
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
    final artworkHeight = math.min(width - 52, maxHeight * .39).clamp(245.0, 360.0).toDouble();
    final topGap = maxHeight < 760 ? 14.0 : 22.0;
    final title = isRecorded ? episode!.title : currentShow.title;
    final speaker = isRecorded ? episode!.host : currentShow.host;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
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
              icon: isRecorded ? Icons.mic_external_on_rounded : Icons.radio_rounded,
            ),
          ),
          const SizedBox(height: 14),
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
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: -.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isRecorded ? speaker : 'Speaker 1 & Speaker 2 · ${speaker}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700),
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
          SizedBox(height: maxHeight < 760 ? 12 : 18),
          Center(
            child: isRecorded ? const _RecordedControls() : const PlayButton(size: 66),
          ),
        ],
      ),
    );
  }
}

class _RecordedControls extends StatelessWidget {
  const _RecordedControls();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
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
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _TransportButton(icon: Icons.skip_previous_rounded),
            SizedBox(width: 24),
            PlayButton(size: 66),
            SizedBox(width: 24),
            _TransportButton(icon: Icons.skip_next_rounded),
          ],
        ),
      ],
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
      height: 52,
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
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
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
        color: const Color(0xF21A1028),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
        border: Border.all(color: Colors.white.withOpacity(.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.50),
            blurRadius: 34,
            offset: const Offset(0, -16),
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
                const SizedBox(height: 10),
                Container(
                  width: 22,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.42),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                _SheetTabs(
                  selectedIndex: _tab,
                  onChanged: (value) {
                    setState(() => _tab = value);
                    if (value != 0) widget.onGoLive();
                  },
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
          if (_tab == 0) ..._previousContent(),
          if (_tab == 1) ..._upcomingContent(),
          if (_tab == 2) ..._chatContent(),
          const SliverToBoxAdapter(child: SizedBox(height: 124)),
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
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
      SliverToBoxAdapter(child: _SearchRow(onFilter: () => _toast(context, 'Filter coming soon'))),
      const SliverToBoxAdapter(child: SizedBox(height: 14)),
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
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            height: 128,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.07),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(.08)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('(Auto swipe)', style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index == 0 ? AppColors.orange : Colors.white.withOpacity(.28),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
      SliverToBoxAdapter(child: _SearchRow(onFilter: () => _toast(context, 'Showing all upcoming shows'))),
      const SliverToBoxAdapter(child: SizedBox(height: 14)),
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

  List<Widget> _chatContent() {
    final messages = const [
      _ChatMessage(name: 'Nadia', text: 'Morning team! Loving this segment today.', time: '09:30am', isWide: false),
      _ChatMessage(name: 'Jason', text: 'Can you play the campus event promo again?', time: '09:29am', isWide: true),
      _ChatMessage(name: 'Aina', text: 'The speaker tips are useful.', time: '09:28am', isWide: false),
      _ChatMessage(name: 'Wei Han', text: 'Shoutout to FASS!', time: '09:27am', isWide: true),
      _ChatMessage(name: 'Sofia', text: 'Please share the podcast link later.', time: '09:26am', isWide: false),
      _ChatMessage(name: 'Daniel', text: 'This is giving real campus radio vibes.', time: '09:25am', isWide: true),
    ];

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ChatBubble(message: messages[index]),
          childCount: messages.length,
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 4),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(.08)),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text('Write a message...', style: TextStyle(color: AppColors.dim, fontWeight: FontWeight.w700)),
                      ),
                      _MiniCircle(label: 'emoji'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _toast(context, 'Message preview only'),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(.24), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.send_rounded, size: 19),
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Disclaimer: do not post unsuitable content.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ];
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SheetTabs extends StatelessWidget {
  const _SheetTabs({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const labels = ['Previous', 'Upcoming', 'Live Chat'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onChanged(index),
              child: Column(
                children: [
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: selected ? 48 : 0,
                    height: 2,
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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
  const _SearchRow({required this.onFilter});

  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
                  SizedBox(width: 10),
                  Text('Search', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Spacer(),
                  _MiniCircle(label: 'magnifying\nglass'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: onFilter,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),
              child: const Center(
                child: Text('Filter', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
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
          color: Colors.white.withOpacity(.08),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 7.2, fontWeight: FontWeight.w900, height: 1.05),
          ),
        ),
      ),
    );
  }
}

class _MiniCircle extends StatelessWidget {
  const _MiniCircle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.10),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, height: .95),
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.name, required this.text, required this.time, required this.isWide});

  final String name;
  final String text;
  final String time;
  final bool isWide;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bubbleWidth = MediaQuery.sizeOf(context).width * (message.isWide ? .48 : .30);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 4),
            child: Text(message.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.muted)),
          ),
          Row(
            children: [
              Container(
                width: bubbleWidth,
                constraints: const BoxConstraints(minHeight: 28),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(.08)),
                ),
                child: Text(message.text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 7),
              Text(message.time, style: const TextStyle(color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
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
