import 'dart:ui';

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

  static const List<Widget> _screens = <Widget>[
    EventsScreen(),
    RadioScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: _screens[_index]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomDock(
              selectedIndex: _index,
              onChanged: (value) => setState(() => _index = value),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomDock extends StatelessWidget {
  const _BottomDock({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      width: double.infinity,
      height: 106 + bottomInset,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 78 + bottomInset,
                  padding: EdgeInsets.fromLTRB(24, 16, 24, bottomInset + 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xEE130A24),
                        AppColors.panel2.withOpacity(.96),
                        const Color(0xEE4A278A),
                      ],
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(.14)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.55),
                        blurRadius: 26,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SideNavItem(
                          icon: Icons.event_available_rounded,
                          label: 'Events',
                          selected: selectedIndex == 0,
                          onTap: () => onChanged(0),
                        ),
                      ),
                      const SizedBox(width: 98),
                      Expanded(
                        child: _SideNavItem(
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                          selected: selectedIndex == 2,
                          onTap: () => onChanged(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: bottomInset + 14,
            child: _CenterPodcastButton(
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterPodcastButton extends StatelessWidget {
  const _CenterPodcastButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected
                  ? AppColors.orangeGradient
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(.18), Colors.white.withOpacity(.08)],
                    ),
              border: Border.all(color: Colors.white.withOpacity(selected ? .28 : .12), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: (selected ? AppColors.orange : AppColors.purple).withOpacity(.28),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.podcasts_rounded,
              size: 34,
              color: Colors.white.withOpacity(selected ? 1 : .92),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Podcast',
            style: TextStyle(
              color: Colors.white.withOpacity(selected ? 1 : .78),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: -.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: selected ? Colors.white : AppColors.muted),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.muted,
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
                  letterSpacing: -.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
