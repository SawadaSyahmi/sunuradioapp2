import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/app_logo.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/play_button.dart';
import '../widgets/section_header.dart';
import '../widgets/show_artwork.dart';
import '../widgets/status_pill.dart';
import 'events_screen.dart';
import 'live_schedule_screen.dart';
import 'now_playing_screen.dart';
import 'podcasts_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 132),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _Header(
                    onSearch: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    ),
                    onNotifications: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _LiveHeroCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _QuickActions(
                    onSchedule: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LiveScheduleScreen()),
                    ),
                    onPodcasts: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PodcastsScreen()),
                    ),
                    onEvents: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EventsScreen()),
                    ),
                  ),
                  const SizedBox(height: 26),
                  SectionHeader(
                    title: 'On today',
                    subtitle: 'Live schedule curated for campus listeners',
                    actionLabel: 'View all',
                    onAction: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LiveScheduleScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _SchedulePreview(),
                  const SizedBox(height: 26),
                  const SectionHeader(title: 'Featured for you', subtitle: 'Fresh picks from SUN4U Radio'),
                  const SizedBox(height: 12),
                  const _FeaturedGrid(),
                  const SizedBox(height: 26),
                  SectionHeader(
                    title: 'Campus events',
                    subtitle: 'What is happening around Sunway',
                    actionLabel: 'Explore',
                    onAction: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EventsScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _HorizontalEvents(),
                  const SizedBox(height: 18),
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
  const _Header({required this.onSearch, required this.onNotifications});

  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppLogo(compact: true),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning',
                style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, fontSize: 12),
              ),
              SizedBox(height: 2),
              Text(
                'Ready to tune in?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: -.2),
              ),
            ],
          ),
        ),
        _RoundIconButton(icon: Icons.search_rounded, onTap: onSearch),
        const SizedBox(width: 8),
        _RoundIconButton(icon: Icons.notifications_none_rounded, onTap: onNotifications),
      ],
    );
  }
}

class _LiveHeroCard extends StatelessWidget {
  const _LiveHeroCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(34),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withOpacity(.24),
              blurRadius: 34,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 350;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    LiveBadge(label: 'ON AIR NOW'),
                    Spacer(),
                    StatusPill(label: '245 LISTENING', icon: Icons.person_rounded),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentShow.title,
                            style: TextStyle(
                              fontSize: narrow ? 29 : 34,
                              fontWeight: FontWeight.w900,
                              height: .95,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'with ${currentShow.host}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: currentShow.tags.map((tag) => _Tag(label: tag)).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    SizedBox(
                      width: narrow ? 82 : 104,
                      height: narrow ? 112 : 130,
                      child: const ShowArtwork(
                        borderRadius: 26,
                        icon: Icons.radio_rounded,
                        showLogo: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentShow.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.82),
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const PlayButton(size: 58),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onSchedule, required this.onPodcasts, required this.onEvents});

  final VoidCallback onSchedule;
  final VoidCallback onPodcasts;
  final VoidCallback onEvents;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ActionChip(icon: Icons.schedule_rounded, label: 'Schedule', onTap: onSchedule)),
        const SizedBox(width: 10),
        Expanded(child: _ActionChip(icon: Icons.podcasts_rounded, label: 'Podcasts', onTap: onPodcasts)),
        const SizedBox(width: 10),
        Expanded(child: _ActionChip(icon: Icons.event_available_rounded, label: 'Events', onTap: onEvents)),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.065),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.09)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.mint, size: 23),
            const SizedBox(height: 7),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _SchedulePreview extends StatelessWidget {
  const _SchedulePreview();

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFF1D102F).withOpacity(.88),
      child: Column(
        children: [
          for (var i = 0; i < schedule.take(4).length; i++)
            _ScheduleRow(show: schedule[i], showDivider: i != 3),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.show, required this.showDivider});

  final dynamic show;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final live = show.isLive == true;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  show.time.split('–').first.trim(),
                  style: TextStyle(
                    color: live ? AppColors.orange : AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: live ? AppColors.mint : Colors.white.withOpacity(.18),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            show.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5),
                          ),
                        ),
                        if (live) ...[
                          const SizedBox(width: 8),
                          const LiveBadge(label: 'LIVE'),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      show.host,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(live ? Icons.play_circle_fill_rounded : Icons.notifications_none_rounded, color: live ? AppColors.orange : AppColors.dim),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.white.withOpacity(.06)),
      ],
    );
  }
}

class _FeaturedGrid extends StatelessWidget {
  const _FeaturedGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FeatureCard(
            title: 'Mic Drop',
            subtitle: 'Spoken Word',
            icon: Icons.mic_external_on_rounded,
            gradient: AppColors.purpleGradient,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FeatureCard(
            title: 'Late Night\nStudy',
            subtitle: 'Focus station',
            icon: Icons.nightlight_round,
            gradient: AppColors.tealGradient,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.title, required this.subtitle, required this.icon, required this.gradient});

  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, height: 1.05)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _HorizontalEvents extends StatelessWidget {
  const _HorizontalEvents();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 164,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final event = events[index];
          return Container(
            width: 172,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: index.isEven ? AppColors.purpleGradient : AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusPill(
                  label: event.date.toUpperCase(),
                  foregroundColor: AppColors.bg,
                  backgroundColor: AppColors.mint,
                ),
                const Spacer(),
                Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                const SizedBox(height: 4),
                Text(event.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ListeningStats extends StatelessWidget {
  const _ListeningStats();

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.bar_chart_rounded, color: AppColors.orange),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('127 students listening now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                SizedBox(height: 3),
                Text('Peak activity is usually between 8–10 AM.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            width: 78,
            height: 46,
            child: CustomPaint(painter: _SparklinePainter()),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
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
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(.075),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Icon(icon, size: 20, color: Colors.white),
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
      ..moveTo(0, size.height * .72)
      ..lineTo(size.width * .20, size.height * .58)
      ..lineTo(size.width * .40, size.height * .64)
      ..lineTo(size.width * .62, size.height * .30)
      ..lineTo(size.width, size.height * .42);
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
