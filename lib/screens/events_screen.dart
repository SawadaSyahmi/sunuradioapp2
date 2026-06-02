import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/section_header.dart';
import '../widgets/status_pill.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 122),
          children: [
            const Text('Events', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -.8)),
            const SizedBox(height: 6),
            const Text('Discover campus events, RSVP, and set reminders.', style: TextStyle(color: AppColors.muted, height: 1.35)),
            const SizedBox(height: 22),
            _FeaturedEvent(
              event: events.first,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EventDetailScreen(event: events.first)),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Upcoming events', subtitle: 'Curated around music, podcasts, and campus life'),
            const SizedBox(height: 12),
            for (final event in events.skip(1))
              _EventCard(
                event: event,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedEvent extends StatelessWidget {
  const _FeaturedEvent({required this.event, required this.onTap});

  final CampusEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(34),
      onTap: onTap,
      child: Container(
        height: 226,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withOpacity(.10)),
        boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(.22), blurRadius: 30, offset: const Offset(0, 16))],
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
          Text(event.title, style: const TextStyle(fontSize: 33, fontWeight: FontWeight.w900, height: .94, letterSpacing: -.9)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.place_rounded, size: 17, color: Colors.white70),
              const SizedBox(width: 5),
              Expanded(child: Text(event.venue, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700))),
            ],
          ),
          const SizedBox(height: 16),
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
              IconButton.filledTonal(
                onPressed: () => _toast(context, 'Reminder set for ${event.title}'),
                icon: const Icon(Icons.notifications_active_rounded),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final CampusEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: FrostedCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 78,
              height: 88,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: event.category == 'Music' ? AppColors.orangeGradient : AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.date.split(' ').first, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, height: .9)),
                  const SizedBox(height: 4),
                  Text(event.date.split(' ').length > 1 ? event.date.split(' ').last.toUpperCase() : '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white70)),
                  const Spacer(),
                  Icon(_iconForCategory(event.category), size: 19, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.category.toUpperCase(), style: const TextStyle(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .35)),
                  const SizedBox(height: 5),
                  Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, height: 1.12)),
                  const SizedBox(height: 5),
                  Text(event.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.3)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _toast(context, 'Reminder set for ${event.title}'),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
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
