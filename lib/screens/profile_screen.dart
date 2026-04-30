import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/section_header.dart';
import 'edit_profile_screen.dart';
import 'saved_library_screen.dart';
import 'interests_screen.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 184),
          children: [
            const Text('Profile', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -.8)),
            const SizedBox(height: 6),
            const Text('Manage your campus radio experience.', style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 22),
            FrostedCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(.22), blurRadius: 18, offset: const Offset(0, 10))],
                    ),
                    child: const Center(child: Text('D', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daniel', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
                        SizedBox(height: 3),
                        Text('Sunway listener', style: TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    icon: const Icon(Icons.edit_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Expanded(child: _StatCard(value: '12h', label: 'Listened')),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    value: '8',
                    label: 'Saved shows',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedLibraryScreen())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    value: '4',
                    label: 'Interests',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InterestsScreen())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Listening history', subtitle: 'Recently played shows'),
            const SizedBox(height: 12),
            FrostedCard(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: [
                  for (var i = 0; i < schedule.take(4).length; i++)
                    _HistoryTile(show: schedule[i], showDivider: i != 3),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Your interests', subtitle: 'Personalise recommended shows and events'),
            const SizedBox(height: 12),
            FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _InterestPill(label: 'Music'),
                      _InterestPill(label: 'Design'),
                      _InterestPill(label: 'Podcasts'),
                      _InterestPill(label: 'Events'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InterestsScreen())),
                      icon: const Icon(Icons.tune_rounded),
                      label: const Text('Edit Interests'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (_) => false,
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, this.onTap});

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 86,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.065),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );

    if (onTap == null) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: card,
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.show, required this.showDivider});

  final dynamic show;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: Colors.white.withOpacity(.07), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.history_rounded, color: AppColors.muted),
          ),
          title: Text(show.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
          subtitle: Text(show.host, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted)),
          trailing: Text(show.time.split('–').first.trim(), style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
        ),
        if (showDivider) Divider(height: 1, indent: 58, color: Colors.white.withOpacity(.06)),
      ],
    );
  }
}

class _InterestPill extends StatelessWidget {
  const _InterestPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.purple.withOpacity(.24)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }
}
