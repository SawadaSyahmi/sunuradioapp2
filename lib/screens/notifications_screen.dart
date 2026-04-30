import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/section_header.dart';
import '../widgets/status_pill.dart';
import 'event_detail_screen.dart';
import 'now_playing_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Notifications', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -.6)),
                  ),
                  TextButton(
                    onPressed: () => _toast(context, 'All notifications marked as read'),
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(.10)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.graphic_eq_rounded, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StatusPill(label: 'LIVE ALERT'),
                          const SizedBox(height: 8),
                          Text(currentShow.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          Text('with ${currentShow.host}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen())),
                      icon: const Icon(Icons.play_arrow_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Recent updates', subtitle: 'Your saved shows, events, and station alerts'),
              const SizedBox(height: 12),
              _NotificationTile(
                icon: Icons.event_available_rounded,
                title: '${events.first.title} is coming up',
                subtitle: '${events.first.date} · ${events.first.venue}',
                time: 'Today',
                unread: true,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(event: events.first))),
              ),
              _NotificationTile(
                icon: Icons.podcasts_rounded,
                title: 'New podcast episode available',
                subtitle: podcasts.first.title,
                time: '2h ago',
                unread: true,
                onTap: () => _toast(context, 'Open Podcasts to play this episode'),
              ),
              _NotificationTile(
                icon: Icons.notifications_active_rounded,
                title: 'Reminder set successfully',
                subtitle: '${schedule[3].title} starts at ${schedule[3].time}',
                time: 'Yesterday',
                onTap: () => _toast(context, 'Reminder is already active'),
              ),
              _NotificationTile(
                icon: Icons.favorite_rounded,
                title: 'Because you like Music',
                subtitle: 'We added more music shows to your recommendations.',
                time: 'Mon',
                onTap: () => _toast(context, 'Recommendations updated'),
              ),
              const SizedBox(height: 20),
              const SectionHeader(title: 'Notification settings', subtitle: 'Prototype toggles for future backend integration'),
              const SizedBox(height: 12),
              FrostedCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: const [
                    _ToggleRow(title: 'Live show alerts', subtitle: 'Notify me when favourite shows go live', value: true),
                    Divider(height: 1, color: Color(0x14FFFFFF)),
                    _ToggleRow(title: 'Event reminders', subtitle: 'Remind me before campus events', value: true),
                    Divider(height: 1, color: Color(0x14FFFFFF)),
                    _ToggleRow(title: 'New podcast drops', subtitle: 'Notify me when new episodes are posted', value: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
    this.unread = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FrostedCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: unread ? AppColors.orangeGradient : AppColors.purpleGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                if (unread)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: AppColors.mint, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.3)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(time, style: const TextStyle(color: AppColors.dim, fontSize: 11, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatefulWidget {
  const _ToggleRow({required this.title, required this.subtitle, required this.value});

  final String title;
  final String subtitle;
  final bool value;

  @override
  State<_ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<_ToggleRow> {
  late bool enabled;

  @override
  void initState() {
    super.initState();
    enabled = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: enabled,
      onChanged: (value) => setState(() => enabled = value),
      title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(widget.subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      activeThumbColor: AppColors.mint,
    );
  }
}
