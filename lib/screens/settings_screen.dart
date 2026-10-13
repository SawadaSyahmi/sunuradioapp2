import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../services/playback_settings.dart';
import '../services/safe_url.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _playInBackground = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await PlaybackSettings.backgroundPlaybackEnabled();
    if (mounted) setState(() => _playInBackground = enabled);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.royalBlue,
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 112),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 20, 28, 16),
              child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            _SettingsBlock(
              title: 'Permissions',
              children: [
                _ToggleRow(
                  label: 'Play in background',
                  value: _playInBackground,
                  onChanged: (value) async {
                    setState(() => _playInBackground = value);
                    await PlaybackSettings.setBackgroundPlaybackEnabled(value);
                  },
                ),
                const _DisabledRow(
                  label: 'Push notifications',
                  value: 'Configure FCM/APNs before enabling',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SettingsBlock(
              title: 'About Us',
              children: [
                _LinkRow(label: 'Terms of Services', onTap: () => _openConfiguredLink('Terms of Services', appConfig.termsUrl)),
                _LinkRow(label: 'Privacy Policy', onTap: () => _openConfiguredLink('Privacy Policy', appConfig.privacyUrl)),
                _LinkRow(label: 'Contact Us', onTap: () => _openConfiguredLink('Contact Us', appConfig.contactUrl)),
              ],
            ),
            const SizedBox(height: 12),
            _SettingsBlock(
              title: 'Join Community',
              children: [
                _SocialRow(icon: Icons.camera_alt_outlined, label: 'Instagram', onTap: () => _openConfiguredLink('Instagram', appConfig.instagramUrl)),
                _SocialRow(icon: Icons.play_circle_outline_rounded, label: 'YouTube', onTap: () => _openConfiguredLink('YouTube', appConfig.youtubeUrl)),
                _SocialRow(icon: Icons.music_note_rounded, label: 'TikTok', onTap: () => _openConfiguredLink('TikTok', appConfig.tiktokUrl)),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                'App Version ${appConfig.appVersion}',
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  final ok = await loadSun4UDataFromSupabase();
                  if (!mounted) return;
                  _toast(ok ? 'Cloud data refreshed' : 'Using local fallback data');
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 17),
                label: const Text('Refresh content', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openConfiguredLink(String label, String raw) async {
    if (raw.trim().isEmpty) {
      _toast('$label link is not configured yet.');
      return;
    }
    final uri = SafeUrl.external(raw);
    if (uri == null) {
      _toast('$label has an invalid or insecure link.');
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) _toast('Unable to open $label.');
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SettingsBlock extends StatelessWidget {
  const _SettingsBlock({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 14, 28, 14),
      color: const Color(0xFF1736BD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          ...children,
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10.5))),
          Transform.scale(
            scale: .74,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisabledRow extends StatelessWidget {
  const _DisabledRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10.5))),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white38, fontSize: 8.5))),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 28,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10.5)),
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10.5)),
          ],
        ),
      ),
    );
  }
}
