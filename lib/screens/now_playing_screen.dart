import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/play_button.dart';
import '../widgets/show_artwork.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB92849), Color(0xFF601B73), Color(0xFF090411)],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 710;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const LiveBadge(label: 'LIVE NOW'),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(.24), borderRadius: BorderRadius.circular(999)),
                          child: const Row(
                            children: [
                              Icon(Icons.person_rounded, size: 14, color: Colors.white70),
                              SizedBox(width: 6),
                              Text('245 LISTENING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: compact ? 16 : 25),
                    Expanded(child: ShowArtwork()),
                    SizedBox(height: compact ? 16 : 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentShow.title,
                                style: const TextStyle(fontSize: 33, fontWeight: FontWeight.w900, letterSpacing: -.8, height: .98),
                              ),
                              const SizedBox(height: 5),
                              Text(currentShow.host, style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(.12), fixedSize: const Size(48, 48)),
                          icon: const Icon(Icons.more_horiz_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: currentShow.tags
                          .map((tag) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _ShowTag(label: tag),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 18),
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
                    SizedBox(height: compact ? 10 : 18),
                    const Center(child: PlayButton(size: 78)),
                    SizedBox(height: compact ? 10 : 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.42),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(.08)),
                      ),
                      child: Row(
                        children: [
                          const Text('UP NEXT', style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w900)),
                          const Spacer(),
                          Text(schedule[2].time.split('–').first.trim(), style: const TextStyle(fontWeight: FontWeight.w800)),
                          Flexible(child: Text('  ·  ${schedule[2].title}', overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted))),
                          const SizedBox(width: 8),
                          const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.muted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to tabs', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
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
