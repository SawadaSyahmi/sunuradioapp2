import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 170),
          children: [
            const Text('Events', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('Discover campus events, RSVP, and set reminders.', style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 24),
            for (final event in events) _EventCard(event: event),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: FrostedCard(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: event.category == 'Music' ? AppColors.orangeGradient : AppColors.purpleGradient,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(999)),
                    child: Text(event.date, style: const TextStyle(color: AppColors.bg, fontWeight: FontWeight.w900, fontSize: 11)),
                  ),
                  const Spacer(),
                  Text(event.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                  Text(event.venue, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.description, style: const TextStyle(color: AppColors.muted, height: 1.45)),
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
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _toast(context, 'Reminder set for ${event.title}'),
                          icon: const Icon(Icons.notifications_active_rounded),
                          label: const Text('Reminder'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
