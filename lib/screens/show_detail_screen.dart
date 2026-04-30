import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/live_badge.dart';
import '../widgets/play_button.dart';
import '../widgets/section_header.dart';
import '../widgets/show_artwork.dart';
import '../widgets/status_pill.dart';
import 'now_playing_screen.dart';

class ShowDetailScreen extends StatelessWidget {
  const ShowDetailScreen({super.key, required this.show});

  final RadioShow show;

  @override
  Widget build(BuildContext context) {
    final live = show.isLive;

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
                    onPressed: () => _toast(context, 'Show saved to your library'),
                    icon: const Icon(Icons.bookmark_add_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: live ? AppColors.orangeGradient : AppColors.purpleGradient,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white.withOpacity(.10)),
                  boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(.22), blurRadius: 30, offset: const Offset(0, 16))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (live) const LiveBadge(label: 'ON AIR NOW') else StatusPill(label: show.time.toUpperCase(), icon: Icons.schedule_rounded),
                        const Spacer(),
                        const StatusPill(label: 'SUN4U SHOW', icon: Icons.radio_rounded),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          width: 118,
                          height: 148,
                          child: ShowArtwork(borderRadius: 28, icon: Icons.radio_rounded, showLogo: false),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(show.title, style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w900, height: .98, letterSpacing: -.8)),
                              const SizedBox(height: 8),
                              Text('with ${show.host}', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: show.tags.map((tag) => _Tag(label: tag)).toList(),
                              ),
                            ],
                          ),
                        ),
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
                      onPressed: live
                          ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen()))
                          : () => _toast(context, 'Reminder set for ${show.title}'),
                      icon: Icon(live ? Icons.play_arrow_rounded : Icons.notifications_active_rounded),
                      label: Text(live ? 'Listen Live' : 'Remind Me'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    onPressed: () => _toast(context, 'Show shared'),
                    icon: const Icon(Icons.ios_share_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'Show overview', subtitle: 'What listeners can expect'),
              const SizedBox(height: 12),
              FrostedCard(
                child: Text(
                  show.description.isNotEmpty
                      ? show.description
                      : '${show.title} brings together campus voices, curated tracks, short conversations, and updates for the Sunway community.',
                  style: const TextStyle(color: AppColors.muted, height: 1.55, fontSize: 15),
                ),
              ),
              const SizedBox(height: 26),
              SectionHeader(title: live ? 'Live chat preview' : 'Discussion prompts', subtitle: live ? 'Prototype chat area for future real-time interaction' : 'Questions this show can collect before going live'),
              const SizedBox(height: 12),
              FrostedCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    _ChatBubble(name: 'Station Crew', message: 'Send your questions and shout-outs during the show.'),
                    SizedBox(height: 10),
                    _ChatBubble(name: 'Maya', message: 'Can you play more indie tracks after the interview?'),
                    SizedBox(height: 10),
                    _ChatInputPreview(),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'Coming up next', subtitle: 'Continue listening after this show'),
              const SizedBox(height: 12),
              for (final item in schedule.where((item) => item.title != show.title).take(2))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FrostedCard(
                    onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ShowDetailScreen(show: item))),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(gradient: AppColors.tealGradient, borderRadius: BorderRadius.circular(18)),
                          child: const Icon(Icons.schedule_rounded),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text('${item.time} · ${item.host}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
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

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
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

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.name, required this.message});

  final String name;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: AppColors.purple.withOpacity(.35),
          child: Text(name.isNotEmpty ? name[0] : '?', style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(.06), borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.mint)),
                const SizedBox(height: 3),
                Text(message, style: const TextStyle(color: AppColors.muted, height: 1.35)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatInputPreview extends StatelessWidget {
  const _ChatInputPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: const [
          Expanded(child: Text('Write a message...', style: TextStyle(color: AppColors.dim, fontWeight: FontWeight.w700))),
          Icon(Icons.send_rounded, color: AppColors.mint, size: 20),
        ],
      ),
    );
  }
}
