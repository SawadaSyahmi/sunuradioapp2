import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/onboarding_store.dart';
import '../widgets/app_logo.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import 'interests_screen.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == 0) {
      _controller.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InterestsScreen()));
    }
  }

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
        gradient: _page == 0 ? AppColors.orangeGradient : AppColors.purpleGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _finishAndEnterApp,
                    child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (value) => setState(() => _page = value),
                    children: const [
                      _WelcomePage(),
                      _TuneInPage(),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    final selected = index == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: selected ? 26 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 22),
                PrimaryButton(label: _page == 0 ? 'Get Started' : 'Continue', onPressed: _next),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: _finishAndEnterApp,
                  child: const Text(
                    'Continue without sign-in',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        AppLogo(),
        SizedBox(height: 48),
        Text(
          'Campus radio,\nreimagined.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1.05),
        ),
        SizedBox(height: 12),
        Text(
          'Stories, music and campus voices,\ncurated for Sunway students.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, height: 1.45),
        ),
        Spacer(),
      ],
    );
  }
}

class _TuneInPage extends StatelessWidget {
  const _TuneInPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(4, (index) {
                final size = 95.0 + index * 56;
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(.05 + index * .025)),
                  ),
                );
              }),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.18),
                  border: Border.all(color: Colors.white.withOpacity(.2)),
                ),
                child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 36),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Text(
          'Tune in to live voices\non campus.',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, height: 1.05),
        ),
        const SizedBox(height: 12),
        const Text(
          'From morning shows to late-night spoken word — we are always on air.',
          style: TextStyle(color: AppColors.muted, height: 1.45),
        ),
        const Spacer(),
      ],
    );
  }
}
