import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/play_button.dart';
import '../widgets/show_artwork.dart';
import 'now_playing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB92849), Color(0xFF601B73), Color(0xFF090411)],
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 165),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 650;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HomeTopBar(),
                      SizedBox(height: compact ? 18 : 24),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                          ),
                          child: ShowArtwork(),
                        ),
                      ),
                      SizedBox(height: compact ? 18 : 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentShow.title,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -.8,
                                    height: .98,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  currentShow.host,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {},
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(.12),
                              fixedSize: const Size(48, 48),
                            ),
                            icon: const Icon(Icons.more_horiz_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          for (final tag in currentShow.tags) ...[
                            _ShowTag(label: tag),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                      const SizedBox(height: 17),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(
                          value: .78,
                          minHeight: 5,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('08:42', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          Text('-01:18', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Center(child: PlayButton(size: 76)),
                    ],
                  );
                },
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: .155,
              minChildSize: .135,
              maxChildSize: .72,
              builder: (context, scrollController) => _DiscoverySheet(controller: scrollController),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const LiveBadge(label: 'LIVE NOW'),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.24),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(.08)),
          ),
          child: const Row(
            children: [
              Icon(Icons.person_rounded, size: 14, color: Colors.white70),
              SizedBox(width: 6),
              Text('245 LISTENING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShowTag extends StatelessWidget {
  const _ShowTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .2),
      ),
    );
  }
}

class _DiscoverySheet extends StatelessWidget {
  const _DiscoverySheet({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xEE12071B),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.36), blurRadius: 28, offset: const Offset(0, -12)),
        ],
      ),
      child: ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 11, 20, 115),
        children: [
          Center(
            child: Container(
              width: 58,
              height: 5,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('UP NEXT', style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w900)),
              const Spacer(),
              Text(schedule[2].time.split('–').first.trim(), style: const TextStyle(fontWeight: FontWeight.w900)),
              Text('  ·  ${schedule[2].title}', style: const TextStyle(color: AppColors.muted)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 22),
          const Text('Discovery', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Swipe up for campus shows, events, and editor picks.', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _ScheduleMiniCard()),
              const SizedBox(width: 12),
              Expanded(child: _EditorsPickCard()),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 138,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _EventTile(index: index),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _InfoTile(title: 'Late Night\nStudy', subtitle: 'Station', icon: Icons.headphones_rounded)),
              SizedBox(width: 12),
              Expanded(child: _InfoTile(title: 'Field Notes', subtitle: '12 Episodes', icon: Icons.trending_up_rounded, green: true)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleMiniCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1748),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's\nSchedule", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, height: 1.05)),
          const SizedBox(height: 14),
          for (final show in schedule.skip(2).take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 3, height: 35, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(999))),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(show.time.split('–').first.trim(), style: const TextStyle(color: AppColors.mint, fontSize: 10, fontWeight: FontWeight.w900)),
                        Text(show.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        Text(show.host, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EditorsPickCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1949),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFDA5A), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("EDITOR'S PICK", style: TextStyle(color: Color(0xFFFFDA5A), fontSize: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          Container(
            height: 92,
            decoration: BoxDecoration(color: const Color(0xFFE0AE4B), borderRadius: BorderRadius.circular(18)),
            child: const Center(child: Icon(Icons.mic_external_on_rounded, size: 38, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          const Text('Mic Drop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const Text('Spoken Word', style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final event = events[index];
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: index.isEven ? AppColors.orangeGradient : AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(999)),
            child: Text(event.date, style: const TextStyle(color: AppColors.bg, fontSize: 9, fontWeight: FontWeight.w900)),
          ),
          const Spacer(),
          Text(event.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          Text(event.venue, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.subtitle, required this.icon, this.green = false});

  final String title;
  final String subtitle;
  final IconData icon;
  final bool green;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: green ? const Color(0xFF0E4734) : const Color(0xFF26133E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: green ? AppColors.mint : AppColors.orange),
          const SizedBox(height: 22),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, height: 1.05)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}
