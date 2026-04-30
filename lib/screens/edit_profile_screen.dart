import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/frosted_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_header.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Daniel');
  final _emailController = TextEditingController(text: 'daniel@student.sunway.edu.my');
  final _programmeController = TextEditingController(text: 'Sunway listener');
  bool _liveAlerts = true;
  bool _eventReminders = true;
  bool _podcastUpdates = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _programmeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Edit profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -.6)),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(38),
                        boxShadow: [BoxShadow(color: AppColors.orange.withOpacity(.24), blurRadius: 26, offset: const Offset(0, 14))],
                      ),
                      child: const Center(child: Text('D', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900))),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.bg, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: AppColors.bg, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Account details', subtitle: 'Prototype form for future user profile backend'),
              const SizedBox(height: 12),
              FrostedCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Display name', prefixIcon: Icon(Icons.person_rounded)),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_rounded)),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _programmeController,
                      decoration: const InputDecoration(labelText: 'Profile label', prefixIcon: Icon(Icons.school_rounded)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const SectionHeader(title: 'Preferences', subtitle: 'Control what SUN4U highlights for you'),
              const SizedBox(height: 12),
              FrostedCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _liveAlerts,
                      onChanged: (value) => setState(() => _liveAlerts = value),
                      title: const Text('Live show alerts', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: const Text('Notify me when favourite shows go live', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      activeThumbColor: AppColors.mint,
                    ),
                    Divider(height: 1, color: Colors.white.withOpacity(.08)),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _eventReminders,
                      onChanged: (value) => setState(() => _eventReminders = value),
                      title: const Text('Event reminders', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: const Text('Remind me about campus showcases', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      activeThumbColor: AppColors.mint,
                    ),
                    Divider(height: 1, color: Colors.white.withOpacity(.08)),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _podcastUpdates,
                      onChanged: (value) => setState(() => _podcastUpdates = value),
                      title: const Text('Podcast updates', style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: const Text('Tell me when new episodes are released', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      activeThumbColor: AppColors.mint,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Save Changes',
                icon: Icons.check_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile changes saved')));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
