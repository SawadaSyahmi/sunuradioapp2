import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import 'interests_screen.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 170),
          children: [
            const Text('Profile', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            FrostedCard(
              child: Row(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Center(child: Text('D', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daniel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                        Text('Sunway listener', style: TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Listening History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  for (final show in schedule.take(4))
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history_rounded, color: AppColors.dim),
                      title: Text(show.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(show.host, style: const TextStyle(color: AppColors.muted)),
                      trailing: Text(show.time.split('–').first, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FrostedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Interests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      Chip(label: Text('Music')),
                      Chip(label: Text('Design')),
                      Chip(label: Text('Podcasts')),
                      Chip(label: Text('Events')),
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
