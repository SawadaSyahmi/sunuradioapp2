import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/app_logo.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/play_button.dart';
import 'now_playing_screen.dart';

class LiveScheduleScreen extends StatelessWidget {
  const LiveScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF07030D), Color(0xFF130927), Color(0xFF07030D)],
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 170),
          children: [
            Row(
              children: [
                const AppLogo(compact: true),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Good morning,\nDaniel',
                    style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w800, height: 1.15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(.08)),
                  ),
                  child: const Column(
                    children: [
                      Text('Wed, 23', style: TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w800)),
                      SizedBox(height: 2),
                      Text('Apr', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF251342),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen())),
                icon: const Icon(Icons.radio_rounded, size: 18),
                label: const Text('JUMP TO NOW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 26),
            for (var i = 0; i < schedule.length; i++) _TimelineTile(show: schedule[i], isFirst: i == 0, isLast: i == schedule.length - 1),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF160B25),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(gradient: AppColors.orangeGradient, borderRadius: BorderRadius.circular(17)),
                    child: const Icon(Icons.chat_bubble_rounded),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Show Detail + Chat', style: TextStyle(fontWeight: FontWeight.w900)),
                        SizedBox(height: 3),
                        Text('Join the live discussion and send questions.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.dim),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.show, required this.isFirst, required this.isLast});

  final RadioShow show;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final live = show.isLive;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Text(
                show.time.split('–').first.trim().replaceAll(':00 ', ''),
                style: TextStyle(
                  color: live ? AppColors.purple : AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 26,
            child: Column(
              children: [
                Expanded(child: Container(width: 2, color: isFirst ? Colors.transparent : Colors.white.withOpacity(.08))),
                Container(
                  width: live ? 9 : 6,
                  height: live ? 9 : 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: live ? AppColors.purple : Colors.white24,
                  ),
                ),
                Expanded(child: Container(width: 2, color: isLast ? Colors.transparent : Colors.white.withOpacity(.08))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: live ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen())) : null,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: live ? const Color(0xFF25183E) : Colors.white.withOpacity(.045),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: live ? AppColors.purple : Colors.white.withOpacity(.06), width: live ? 1.4 : 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(child: Text(show.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15))),
                                if (live) ...[
                                  const SizedBox(width: 8),
                                  const LiveBadge(label: 'LIVE'),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(show.host, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                            if (live) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  _TinyPill(label: 'AUDIO'),
                                  SizedBox(width: 6),
                                  _TinyPill(label: '245'),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      live ? const PlayButton(size: 44) : const Icon(Icons.notifications_none_rounded, color: AppColors.dim),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.08), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(fontSize: 9, color: AppColors.muted, fontWeight: FontWeight.w900)),
    );
  }
}
