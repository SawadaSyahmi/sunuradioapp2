import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/status_pill.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 126),
          children: [
            Row(
              children: const [
                AppLogo(compact: true),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FrostedCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.person_rounded, size: 32),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SUN4U Listener', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        SizedBox(height: 4),
                        Text('FASS campus radio profile', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  const StatusPill(label: 'BETA'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const _SettingsSection(
              title: 'Playback',
              items: [
                _SettingsItem(icon: Icons.volume_up_rounded, title: 'Audio quality', subtitle: 'Auto stream quality'),
                _SettingsItem(icon: Icons.notifications_active_rounded, title: 'Show reminders', subtitle: 'Notify before upcoming live shows'),
                _SettingsItem(icon: Icons.download_done_rounded, title: 'Offline saved shows', subtitle: 'Manage downloaded podcast episodes'),
              ],
            ),
            const SizedBox(height: 18),
            const _SettingsSection(
              title: 'App',
              items: [
                _SettingsItem(icon: Icons.dark_mode_rounded, title: 'Theme', subtitle: 'SUN4U dark gradient theme'),
                _SettingsItem(icon: Icons.privacy_tip_rounded, title: 'Community safety', subtitle: 'Live chat guidelines and reporting'),
                _SettingsItem(icon: Icons.info_rounded, title: 'About SUN4U Radio', subtitle: 'Version 1.0 prototype'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.items});

  final String title;
  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: const TextStyle(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: .4)),
          ),
          for (var i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1) Divider(height: 1, color: Colors.white.withOpacity(.08), indent: 70),
          ],
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title setting'))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(.08)),
              ),
              child: Icon(icon, color: AppColors.mint, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.dim),
          ],
        ),
      ),
    );
  }
}
