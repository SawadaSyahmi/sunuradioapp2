import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/app_logo.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/status_pill.dart';
import 'settings_detail_screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 122),
          children: [
            Row(
              children: const [
                AppLogo(compact: true),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, letterSpacing: -.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _ProfileCard(onTap: () => _open(context, const ProfileScreen())),
            const SizedBox(height: 18),
            _QuickActions(
              onSaved: () => _open(context, const SavedEpisodesScreen()),
              onReminder: () => _open(context, const RemindersScreen()),
              onFeedback: () => _open(context, const FeedbackScreen()),
            ),
            const SizedBox(height: 20),
            _SettingsSection(
              title: 'Playback',
              items: [
                _SettingsItem(
                  icon: Icons.volume_up_rounded,
                  iconColor: AppColors.mint,
                  title: 'Audio quality',
                  subtitle: 'Auto stream quality and data saver mode',
                  onTap: () => _open(context, const AudioQualityScreen()),
                ),
                _SettingsItem(
                  icon: Icons.notifications_active_rounded,
                  iconColor: AppColors.orange,
                  title: 'Show reminders',
                  subtitle: 'Notify before upcoming live shows',
                  onTap: () => _open(context, const RemindersScreen()),
                ),
                _SettingsItem(
                  icon: Icons.bookmarks_rounded,
                  iconColor: AppColors.pink,
                  title: 'Saved shows',
                  subtitle: 'Manage saved podcast episodes',
                  onTap: () => _open(context, const SavedEpisodesScreen()),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _SettingsSection(
              title: 'App & Community',
              items: [
                _SettingsItem(
                  icon: Icons.cloud_sync_rounded,
                  iconColor: AppColors.orange,
                  title: 'Refresh cloud data',
                  subtitle: sun4ULoadedFromSupabase ? 'Loaded from Supabase' : 'Using fallback data',
                  onTap: () async {
                    final ok = await loadSun4UDataFromSupabase();
                    if (!context.mounted) return;
                    _toast(
                      context,
                      ok ? 'Supabase data refreshed' : 'Still using fallback: ${sun4ULastLoadError ?? 'unknown error'}',
                    );
                  },
                ),
                _SettingsItem(
                  icon: Icons.dark_mode_rounded,
                  iconColor: AppColors.violet,
                  title: 'Theme',
                  subtitle: 'SUN4U dark gradient theme',
                  onTap: () => _toast(context, 'Theme is already set to SUN4U dark mode'),
                ),
                _SettingsItem(
                  icon: Icons.privacy_tip_rounded,
                  iconColor: AppColors.mint,
                  title: 'Community safety',
                  subtitle: 'Live chat guidelines and reporting',
                  onTap: () => _open(context, const CommunitySafetyScreen()),
                ),
                _SettingsItem(
                  icon: Icons.lock_rounded,
                  iconColor: AppColors.blue,
                  title: 'Privacy & data',
                  subtitle: 'Prototype privacy controls',
                  onTap: () => _open(context, const PrivacyDataScreen()),
                ),
                _SettingsItem(
                  icon: Icons.feedback_rounded,
                  iconColor: AppColors.orange,
                  title: 'Feedback',
                  subtitle: 'Send app comments to the SUN4U team',
                  onTap: () => _open(context, const FeedbackScreen()),
                ),
                _SettingsItem(
                  icon: Icons.info_rounded,
                  iconColor: AppColors.muted,
                  title: 'About SUN4U Radio',
                  subtitle: 'Version 1.0 prototype',
                  onTap: () => _open(context, const AboutSun4UScreen()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.orange.withOpacity(.94),
              AppColors.pink.withOpacity(.86),
              AppColors.purple.withOpacity(.94),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(.18)),
          boxShadow: [
            BoxShadow(color: AppColors.orange.withOpacity(.22), blurRadius: 30, offset: const Offset(0, 16)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.18),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(.22)),
              ),
              child: const Icon(Icons.person_rounded, size: 35),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text('SUN4U Listener', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: -.25))),
                      SizedBox(width: 8),
                      StatusPill(label: 'BETA'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text('FASS campus radio profile', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onSaved, required this.onReminder, required this.onFeedback});

  final VoidCallback onSaved;
  final VoidCallback onReminder;
  final VoidCallback onFeedback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _QuickAction(icon: Icons.bookmark_rounded, label: 'Saved', onTap: onSaved)),
        const SizedBox(width: 10),
        Expanded(child: _QuickAction(icon: Icons.notifications_rounded, label: 'Alerts', onTap: onReminder)),
        const SizedBox(width: 10),
        Expanded(child: _QuickAction(icon: Icons.feedback_rounded, label: 'Feedback', onTap: onFeedback)),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FrostedCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      radius: 22,
      child: Column(
        children: [
          Icon(icon, color: AppColors.orange, size: 22),
          const SizedBox(height: 7),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
        ],
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
      radius: 28,
      color: Colors.white.withOpacity(.065),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title.toUpperCase(), style: const TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: .55)),
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
  const _SettingsItem({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(.13),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: iconColor.withOpacity(.20)),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, letterSpacing: -.15)),
                  const SizedBox(height: 3),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11.5, fontWeight: FontWeight.w600)),
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
