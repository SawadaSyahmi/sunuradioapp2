import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'events_screen.dart';
import 'radio_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 1;

  static const _screens = [
    EventsScreen(),
    RadioScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: Container(
          height: 86,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xF20F071A),
            borderRadius: BorderRadius.circular(42),
            border: Border.all(color: Colors.white.withOpacity(.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.42),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: AppColors.purple.withOpacity(.18),
                blurRadius: 34,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavBubble(
                icon: Icons.event_available_rounded,
                label: 'Events',
                selected: _index == 0,
                onTap: () => _select(0),
              ),
              _NavBubble(
                icon: Icons.podcasts_rounded,
                label: 'Podcast',
                selected: _index == 1,
                onTap: () => _select(1),
              ),
              _NavBubble(
                icon: Icons.settings_rounded,
                label: 'Settings',
                selected: _index == 2,
                onTap: () => _select(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _select(int index) => setState(() => _index = index);
}

class _NavBubble extends StatelessWidget {
  const _NavBubble({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: selected ? 72 : 60,
          height: selected ? 72 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: selected ? AppColors.orangeGradient : null,
            color: selected ? null : Colors.white.withOpacity(.075),
            border: Border.all(
              color: selected ? Colors.white.withOpacity(.18) : Colors.white.withOpacity(.08),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.orange.withOpacity(.32),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: selected ? 23 : 21, color: selected ? Colors.white : AppColors.muted),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.muted,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
