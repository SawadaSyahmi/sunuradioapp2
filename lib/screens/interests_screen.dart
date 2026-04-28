import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import 'all_set_screen.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Set<String> _selected = {'Music', 'Design', 'Podcasts', 'Events'};

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
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AllSetScreen()),
                    ),
                    child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                const Spacer(),
                const Text(
                  'What moves you?',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.02),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pick at least 3 — we will curate your feed.',
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: interests.map((interest) {
                    final selected = _selected.contains(interest);
                    return FilterChip(
                      label: Text(interest),
                      selected: selected,
                      showCheckmark: false,
                      onSelected: (_) {
                        setState(() {
                          selected ? _selected.remove(interest) : _selected.add(interest);
                        });
                      },
                    );
                  }).toList(),
                ),
                const Spacer(flex: 2),
                PrimaryButton(
                  label: 'Continue (${_selected.length})',
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
