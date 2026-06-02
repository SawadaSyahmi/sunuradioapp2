import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/section_header.dart';
import '../widgets/status_pill.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailScaffold(
      title: 'Profile',
      subtitle: 'Listener profile and campus radio identity',
      children: [
        _ProfileHeader(),
        SizedBox(height: 18),
        SectionHeader(title: 'Listening stats', subtitle: 'Prototype UI for future account data'),
        SizedBox(height: 12),
        _StatsGrid(),
      ],
    );
  }
}

class AudioQualityScreen extends StatefulWidget {
  const AudioQualityScreen({super.key});

  @override
  State<AudioQualityScreen> createState() => _AudioQualityScreenState();
}

class _AudioQualityScreenState extends State<AudioQualityScreen> {
  String _quality = 'Auto';

  @override
  Widget build(BuildContext context) {
    return _SettingsDetailScaffold(
      title: 'Audio quality',
      subtitle: 'Choose how SUN4U handles streaming quality',
      children: [
        FrostedCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final option in const ['Auto', 'High', 'Data saver'])
                RadioListTile<String>(
                  value: option,
                  groupValue: _quality,
                  activeColor: AppColors.orange,
                  onChanged: (value) => setState(() => _quality = value ?? _quality),
                  title: Text(option, style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text(_qualityDescription(option), style: const TextStyle(color: AppColors.muted)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FrostedCard(
          child: Row(
            children: const [
              Icon(Icons.info_rounded, color: AppColors.mint),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Live radio uses your configured stream URL. Replace the temporary test stream with the official SUN4U endpoint when ready.',
                  style: TextStyle(color: AppColors.muted, height: 1.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _qualityDescription(String option) {
    switch (option) {
      case 'High':
        return 'Prioritise stable high quality when Wi-Fi is available.';
      case 'Data saver':
        return 'Lower data usage for mobile network listening.';
      default:
        return 'Let the app choose the best stream quality.';
    }
  }
}

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upcoming = schedule.where((show) => !show.isLive).toList();

    return _SettingsDetailScaffold(
      title: 'Reminders',
      subtitle: 'Shows and events you may want to remember',
      children: [
        for (final show in upcoming.take(5))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReminderCard(showTitle: show.title, time: show.time, host: show.host),
          ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _toast(context, 'Reminder settings saved'),
            icon: const Icon(Icons.notifications_active_rounded),
            label: const Text('Save reminder preferences'),
          ),
        ),
      ],
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class SavedEpisodesScreen extends StatelessWidget {
  const SavedEpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingsDetailScaffold(
      title: 'Saved shows',
      subtitle: 'Prototype library for saved or downloaded episodes',
      children: [
        for (final episode in podcasts)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FrostedCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: episode.category == 'Research' ? AppColors.tealGradient : AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.podcasts_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(episode.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text('${episode.host} · ${episode.duration}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${episode.title} removed from saved'))),
                    icon: const Icon(Icons.bookmark_remove_rounded),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class CommunitySafetyScreen extends StatelessWidget {
  const CommunitySafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailScaffold(
      title: 'Community safety',
      subtitle: 'Guidelines for live chat and campus interaction',
      children: [
        _GuidelineCard(
          icon: Icons.favorite_rounded,
          title: 'Be respectful',
          body: 'Keep chat friendly, inclusive, and suitable for a campus audience.',
        ),
        SizedBox(height: 12),
        _GuidelineCard(
          icon: Icons.report_rounded,
          title: 'Report unsuitable content',
          body: 'A reporting flow can be connected later to Firebase or your moderation dashboard.',
        ),
        SizedBox(height: 12),
        _GuidelineCard(
          icon: Icons.privacy_tip_rounded,
          title: 'Protect privacy',
          body: 'Do not share private information in live chat or podcast comments.',
        ),
      ],
    );
  }
}


class PrivacyDataScreen extends StatelessWidget {
  const PrivacyDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailScaffold(
      title: 'Privacy & data',
      subtitle: 'Prototype controls for account, chat, and listening data',
      children: [
        _GuidelineCard(
          icon: Icons.account_circle_rounded,
          title: 'Account data',
          body: 'Future Firebase authentication can store listener profiles, saved shows, and RSVP activity securely.',
        ),
        SizedBox(height: 12),
        _GuidelineCard(
          icon: Icons.chat_bubble_rounded,
          title: 'Live chat data',
          body: 'Chat messages should be moderated and linked to reporting tools before public release.',
        ),
        SizedBox(height: 12),
        _GuidelineCard(
          icon: Icons.delete_sweep_rounded,
          title: 'Delete requests',
          body: 'A future release can include a request form for deleting saved profile or chat data.',
        ),
      ],
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingsDetailScaffold(
      title: 'Feedback',
      subtitle: 'Collect comments before connecting a backend form',
      children: [
        FrostedCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('What should we improve?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write feedback about the app layout, radio player, events, or live chat...',
                  filled: true,
                  fillColor: Colors.white.withOpacity(.06),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback saved as prototype preview'))),
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Submit feedback'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AboutSun4UScreen extends StatelessWidget {
  const AboutSun4UScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailScaffold(
      title: 'About SUN4U Radio',
      subtitle: 'Campus radio app prototype',
      children: [
        FrostedCard(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SUN4U Radio', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -.6)),
              SizedBox(height: 8),
              Text(
                'A student-friendly radio and podcast application for live shows, recorded episodes, campus events, and moderated live chat.',
                style: TextStyle(color: AppColors.muted, height: 1.5),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  StatusPill(label: 'VERSION 1.0'),
                  SizedBox(width: 8),
                  StatusPill(label: 'PROTOTYPE', foregroundColor: AppColors.bg, backgroundColor: AppColors.mint),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
        _GuidelineCard(
          icon: Icons.radio_rounded,
          title: 'Core modules',
          body: 'Live player, podcast library, upcoming shows, live chat, events, reminders, and settings pages.',
        ),
        SizedBox(height: 12),
        _GuidelineCard(
          icon: Icons.code_rounded,
          title: 'Next integration step',
          body: 'Connect the official radio stream URL, Firebase database, authentication, and push notifications.',
        ),
      ],
    );
  }
}

class _SettingsDetailScaffold extends StatelessWidget {
  const _SettingsDetailScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title shared'))),
                    icon: const Icon(Icons.ios_share_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -.7)),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: AppColors.muted, height: 1.4)),
              const SizedBox(height: 22),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(.22), blurRadius: 22)],
            ),
            child: const Icon(Icons.person_rounded, size: 38),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SUN4U Listener', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('FASS campus radio profile', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                SizedBox(height: 8),
                StatusPill(label: 'BETA ACCOUNT'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatBox(value: '24', label: 'Listened')),
        SizedBox(width: 10),
        Expanded(child: _StatBox(value: '6', label: 'Saved')),
        SizedBox(width: 10),
        Expanded(child: _StatBox(value: '3', label: 'RSVP')),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatefulWidget {
  const _ReminderCard({required this.showTitle, required this.time, required this.host});

  final String showTitle;
  final String time;
  final String host;

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(gradient: AppColors.purpleGradient, borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.radio_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.showTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${widget.time} · ${widget.host}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeColor: AppColors.orange,
            onChanged: (value) => setState(() => enabled = value),
          ),
        ],
      ),
    );
  }
}

class _GuidelineCard extends StatelessWidget {
  const _GuidelineCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.08)),
            ),
            child: Icon(icon, color: AppColors.mint, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(color: AppColors.muted, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
