import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/play_button.dart';
import '../widgets/show_artwork.dart';
import '../widgets/status_pill.dart';
import 'show_detail_screen.dart';

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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 720;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                        const SizedBox(width: 8),
                        const StatusPill(label: 'LIVE NOW', icon: Icons.graphic_eq_rounded),
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
                    SizedBox(height: compact ? 16 : 24),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 390),
                          child: const ShowArtwork(borderRadius: 38, icon: Icons.radio_rounded),
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 16 : 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentShow.title,
                                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -.9, height: .98),
                              ),
                              const SizedBox(height: 6),
                              Text('with ${currentShow.host}', style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ShowDetailScreen(show: currentShow)),
                          ),
                          icon: const Icon(Icons.more_horiz_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: currentShow.tags.map((tag) => _ShowTag(label: tag)).toList(),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.28),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(.10)),
                      ),
                      child: Column(
                        children: [
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
                              Text('08:42', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w700)),
                              Text('-01:18', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          SizedBox(height: compact ? 12 : 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ControlButton(
                                icon: Icons.skip_previous_rounded,
                                onTap: () => _toast(context, 'Live radio cannot skip backward'),
                              ),
                              const SizedBox(width: 18),
                              const PlayButton(size: 78),
                              const SizedBox(width: 18),
                              _ControlButton(
                                icon: Icons.skip_next_rounded,
                                onTap: () => _toast(context, 'Live radio cannot skip forward'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 12 : 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.35),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white.withOpacity(.08)),
                      ),
                      child: Row(
                        children: [
                          const Text('UP NEXT', style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w900)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${schedule[2].time.split('–').first.trim()} · ${schedule[2].title}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.muted),
                        ],
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

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.09),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.10)),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
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
