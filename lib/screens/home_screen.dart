import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/app_logo.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/play_button.dart';
import 'now_playing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 220),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _Header(),
                  const SizedBox(height: 22),
                  _HeroPlayer(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen()))),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _ScheduleCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _EditorsPickCard()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _HorizontalEvents(),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(child: _SmallInfoCard(title: 'Late Night\nStudy', subtitle: 'Station', icon: Icons.headphones_rounded)),
                      SizedBox(width: 12),
                      Expanded(child: _SmallInfoCard(title: 'Field Notes', subtitle: '12 Episodes', icon: Icons.trending_up_rounded, green: true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _ListeningStats(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppLogo(compact: true),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Good morning, Daniel',
            style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton.filled(
          onPressed: () {},
          style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(.08)),
          icon: const Icon(Icons.search_rounded),
        ),
      ],
    );
  }
}

class _HeroPlayer extends StatelessWidget {
  const _HeroPlayer({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(.25), blurRadius: 36, offset: const Offset(0, 18))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const LiveBadge(label: 'ON AIR NOW'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(999)),
                  child: const Row(
                    children: [
                      Icon(Icons.person_rounded, size: 14, color: Colors.white),
                      SizedBox(width: 5),
                      Text('245', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 52),
            Text(
              currentShow.title,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: .95),
            ),
            const SizedBox(height: 8),
            Text('with ${currentShow.host}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 18),
            Row(
              children: [
                for (final tag in currentShow.tags) ...[
                  _Tag(label: tag),
                  const SizedBox(width: 8),
                ],
                const Spacer(),
                const PlayButton(size: 58),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      color: const Color(0xFF2A1646).withOpacity(.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's\nSchedule", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.05)),
          const SizedBox(height: 16),
          for (final show in schedule.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 3, height: 36, decoration: BoxDecoration(color: show.isLive ? AppColors.orange : AppColors.mint, borderRadius: BorderRadius.circular(999))),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(show.time, style: const TextStyle(color: AppColors.mint, fontSize: 10, fontWeight: FontWeight.w900)),
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
    return FrostedCard(
      color: const Color(0xFF2C1949).withOpacity(.9),
      borderColor: const Color(0xFFFFDA5A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("EDITOR'S PICK", style: TextStyle(color: Color(0xFFFFDA5A), fontSize: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Container(
            height: 96,
            decoration: BoxDecoration(color: const Color(0xFFE2B04C), borderRadius: BorderRadius.circular(20)),
            child: const Center(child: Icon(Icons.mic_external_on_rounded, size: 42)),
          ),
          const SizedBox(height: 12),
          const Text('Mic Drop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const Text('Spoken Word', style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HorizontalEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final event = events[index];
          return Container(
            width: 158,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: index.isEven ? AppColors.purpleGradient : AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(26),
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
        },
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  const _SmallInfoCard({required this.title, required this.subtitle, required this.icon, this.green = false});

  final String title;
  final String subtitle;
  final IconData icon;
  final bool green;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      color: green ? const Color(0xFF0F4A35) : const Color(0xFF2A1646),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: green ? AppColors.mint : AppColors.orange),
          const SizedBox(height: 26),
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, height: 1.05)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ListeningStats extends StatelessWidget {
  const _ListeningStats();

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.bar_chart_rounded, color: AppColors.dim),
                SizedBox(height: 18),
                Text('127', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                Text('students listening\nright now', style: TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            width: 96,
            height: 70,
            child: CustomPaint(painter: _SparklinePainter()),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.orange
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * .7)
      ..lineTo(size.width * .22, size.height * .56)
      ..lineTo(size.width * .40, size.height * .62)
      ..lineTo(size.width * .60, size.height * .35)
      ..lineTo(size.width, size.height * .45);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(999)),
      child: Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }
}
