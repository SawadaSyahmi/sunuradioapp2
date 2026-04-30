import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/section_header.dart';
import '../widgets/status_pill.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final related = events.where((item) => item.title != event.title).take(2).toList();

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
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () => _toast(context, 'Event shared'),
                    icon: const Icon(Icons.ios_share_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 260,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: event.category == 'Music' ? AppColors.orangeGradient : AppColors.purpleGradient,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white.withOpacity(.10)),
                  boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(.22), blurRadius: 30, offset: const Offset(0, 16))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusPill(label: event.date.toUpperCase(), foregroundColor: AppColors.bg, backgroundColor: AppColors.mint),
                        const SizedBox(width: 8),
                        StatusPill(label: event.category.toUpperCase(), icon: Icons.local_activity_rounded),
                      ],
                    ),
                    const Spacer(),
                    Icon(_iconForCategory(event.category), size: 44, color: Colors.white.withOpacity(.92)),
                    const SizedBox(height: 18),
                    Text(event.title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, height: .95, letterSpacing: -1)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.place_rounded, color: Colors.white70, size: 18),
                        const SizedBox(width: 6),
                        Expanded(child: Text(event.venue, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _toast(context, 'RSVP saved for ${event.title}'),
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text('RSVP'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _toast(context, 'Reminder set for ${event.title}'),
                      icon: const Icon(Icons.notifications_active_rounded),
                      label: const Text('Remind me'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'About this event', subtitle: 'Details for students and campus listeners'),
              const SizedBox(height: 12),
              FrostedCard(
                child: Text(event.description, style: const TextStyle(color: AppColors.muted, height: 1.55, fontSize: 15)),
              ),
              const SizedBox(height: 18),
              FrostedCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(icon: Icons.calendar_month_rounded, title: 'Date', value: event.date),
                    Divider(height: 24, color: Colors.white.withOpacity(.08)),
                    _InfoRow(icon: Icons.place_rounded, title: 'Venue', value: event.venue),
                    Divider(height: 24, color: Colors.white.withOpacity(.08)),
                    _InfoRow(icon: Icons.confirmation_number_rounded, title: 'Entry', value: 'Open to Sunway community'),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'More campus events', subtitle: 'Explore other SUN4U picks'),
              const SizedBox(height: 12),
              for (final item in related)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FrostedCard(
                    onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => EventDetailScreen(event: item))),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(gradient: AppColors.tealGradient, borderRadius: BorderRadius.circular(18)),
                          child: Icon(_iconForCategory(item.category), color: Colors.white),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text('${item.date} · ${item.venue}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
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
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Music':
        return Icons.music_note_rounded;
      case 'Podcast':
        return Icons.podcasts_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: Colors.white.withOpacity(.07), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: AppColors.mint, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }
}
