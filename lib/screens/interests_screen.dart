import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../services/onboarding_store.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import 'all_set_screen.dart';
import 'main_shell.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Set<String> _selected = {'Music', 'Design', 'Podcasts', 'Events'};

  Future<void> _finishAndEnterApp() async {
    await OnboardingStore.markCompleted();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _finishAndEnterApp,
                    child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'What moves you?',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.02, letterSpacing: -.8),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pick at least 3 topics so SUN4U can curate your home feed.',
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: interests.map((interest) {
                        final selected = _selected.contains(interest);
                        return FilterChip(
                          label: Text(interest),
                          selected: selected,
                          showCheckmark: false,
                          avatar: selected ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                          onSelected: (_) {
                            setState(() {
                              selected ? _selected.remove(interest) : _selected.add(interest);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${_selected.length} selected',
                  style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AllSetScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
