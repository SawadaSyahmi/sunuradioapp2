import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/figma_media.dart';
import '../widgets/gradient_background.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(36, 22, 0, 122),
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 36),
              child: Text('Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 36),
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _EventHeroCard(
                    event: event,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 9),
            const Padding(padding: EdgeInsets.only(right: 36), child: _DotsIndicator()),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(right: 36),
              child: _SearchRow(onFilter: () => _toast(context, 'Filter coming soon')),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.only(right: 36),
              child: Column(
                children: [
                  for (final event in events)
                    _EventListCard(
                      event: event,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
                      ),
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

class _EventHeroCard extends StatelessWidget {
  const _EventHeroCard({required this.event, required this.onTap});

  final CampusEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 276,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FigmaMedia(
            imageUrl: event.artworkUrl,
            title: event.title,
            category: event.category,
            icon: Icons.local_activity_rounded,
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: index == 0 ? 6 : 5,
          height: index == 0 ? 6 : 5,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0 ? AppColors.orange : Colors.white.withOpacity(.82),
          ),
        );
      }),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.onFilter});

  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: const [
                Expanded(
                  child: Text('Search', style: TextStyle(color: Color(0xFFC6C6C6), fontSize: 13, fontWeight: FontWeight.w400)),
                ),
                Icon(Icons.search_rounded, color: AppColors.royalBlue, size: 25),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onFilter,
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.tune_rounded, color: AppColors.royalBlue, size: 24),
          ),
        ),
      ],
    );
  }
}

class _EventListCard extends StatelessWidget {
  const _EventListCard({required this.event, required this.onTap});

  final CampusEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 128,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: FigmaMedia(
                imageUrl: event.imageUrl,
                title: event.title,
                category: event.category,
                icon: Icons.local_activity_rounded,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 15, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.date, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.royalBlue, fontSize: 8, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 19, height: .88, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'by ${event.organiser.isEmpty ? event.category : event.organiser}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 8, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
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
