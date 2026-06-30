import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/radio_models.dart';
import '../widgets/figma_media.dart';
import '../widgets/gradient_background.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 320,
              color: AppColors.royalBlue,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 17, 28, 15),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          ),
                          const SizedBox(width: 2),
                          const Text('Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _toast(context, 'Event shared'),
                            icon: const Icon(Icons.share_rounded, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FigmaMedia(
                        imageUrl: event.artworkUrl,
                        title: event.title,
                        category: event.category,
                        icon: Icons.local_activity_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(36, 25, 36, 130),
              decoration: BoxDecoration(gradient: AppColors.blueGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.date, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, height: .9, letterSpacing: -.7),
                  ),
                  const SizedBox(height: 24),
                  Text(event.description, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.04, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 22),
                  _InfoBlock(event: event),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _toast(context, event.rsvpUrl.isEmpty ? 'RSVP saved for ${event.title}' : 'Opening RSVP link'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('RSVP Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date:  ${event.date}', style: const TextStyle(fontSize: 13, height: 1.08)),
        if (event.time.trim().isNotEmpty) Text('Time: ${event.time}', style: const TextStyle(fontSize: 13, height: 1.08)),
        Text('Venue: ${event.venue}', style: const TextStyle(fontSize: 13, height: 1.08)),
        Text('Participation: ${event.entry}', style: const TextStyle(fontSize: 13, height: 1.08)),
        if (event.organiser.trim().isNotEmpty) Text('Organiser: ${event.organiser}', style: const TextStyle(fontSize: 13, height: 1.08)),
      ],
    );
  }
}
