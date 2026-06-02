import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/app_logo.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/play_button.dart';
import '../widgets/section_header.dart';
import '../widgets/status_pill.dart';
import 'now_playing_screen.dart';
import 'show_detail_screen.dart';

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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 184),
          children: [
            Row(
              children: [
                const AppLogo(compact: true),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Live radio', style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, fontSize: 12)),
                      SizedBox(height: 2),
                      Text('Today on SUN4U', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.075),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(.08)),
                  ),
                  child: const Column(
                    children: [
                      Text('Today', style: TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w800)),
                      SizedBox(height: 2),
                      Text('Live', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _NowOnAirCard(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen())),
            ),
            const SizedBox(height: 26),
            const SectionHeader(title: 'Full schedule', subtitle: 'Follow the live timeline for today'),
            const SizedBox(height: 12),
            for (var i = 0; i < schedule.length; i++) _TimelineTile(show: schedule[i], isFirst: i == 0, isLast: i == schedule.length - 1),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShowDetailScreen(show: currentShow))),
              child: Container(
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
                          Text('Show detail + live chat', style: TextStyle(fontWeight: FontWeight.w900)),
                          SizedBox(height: 3),
                          Text('Join the discussion and send questions.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
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
    );
  }
}

class _NowOnAirCard extends StatelessWidget {
  const _NowOnAirCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(.10)),
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(gradient: AppColors.orangeGradient, borderRadius: BorderRadius.circular(22)),
              child: const Icon(Icons.radio_rounded, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusPill(label: 'ON AIR NOW', icon: Icons.circle),
                  const SizedBox(height: 8),
                  Text(currentShow.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text('with ${currentShow.host}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const PlayButton(size: 50),
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
            width: 52,
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Text(
                show.time.split('–').first.trim().replaceAll(':00 ', ''),
                style: TextStyle(
                  color: live ? AppColors.orange : AppColors.muted,
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
                  width: live ? 11 : 7,
                  height: live ? 11 : 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: live ? AppColors.mint : Colors.white24,
                    boxShadow: live ? [BoxShadow(color: AppColors.mint.withOpacity(.45), blurRadius: 12)] : null,
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
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => live ? const NowPlayingScreen() : ShowDetailScreen(show: show))),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: live ? const Color(0xFF25183E) : Colors.white.withOpacity(.045),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: live ? AppColors.mint.withOpacity(.55) : Colors.white.withOpacity(.06), width: live ? 1.4 : 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(child: Text(show.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5))),
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
