import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../services/onboarding_store.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/play_button.dart';
import '../widgets/status_pill.dart';
import 'main_shell.dart';

class AllSetScreen extends StatelessWidget {
  const AllSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradient: AppColors.tealGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 22),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 94,
                  height: 94,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.16),
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [BoxShadow(color: AppColors.mint.withOpacity(.28), blurRadius: 34, offset: const Offset(0, 14))],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 42),
                ),
                const SizedBox(height: 42),
                const Text(
                  "You're tuned in.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.02, letterSpacing: -.8),
                ),
                const SizedBox(height: 12),
                Text(
                  '${currentShow.title} is live right now with ${currentShow.host}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, height: 1.45),
                ),
                const SizedBox(height: 34),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(.22)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: AppColors.orangeGradient,
                        ),
                        child: const Icon(Icons.headphones_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const StatusPill(label: 'LIVE NOW'),
                            const SizedBox(height: 8),
                            Text(currentShow.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                            Text(currentShow.host, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const PlayButton(size: 48),
                    ],
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Start Listening',
                  onPressed: () async {
                    await OnboardingStore.markCompleted();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainShell()),
                      (_) => false,
                    );
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
