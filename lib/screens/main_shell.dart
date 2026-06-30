import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import 'events_screen.dart';
import 'radio_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _index = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadSun4UDataFromSupabase();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadSun4UDataFromSupabase();
    }
  }

  List<Widget> _buildScreens(int version) {
    return <Widget>[
      EventsScreen(key: ValueKey('events_$version')),
      RadioScreen(key: ValueKey('radio_$version')),
      SettingsScreen(key: ValueKey('settings_$version')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: ValueListenableBuilder<int>(
              valueListenable: sun4UDataVersion,
              builder: (context, version, _) {
                return IndexedStack(index: _index, children: _buildScreens(version));
              },
            ),
          ),
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
      height: 86 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 74 + bottomInset,
              padding: EdgeInsets.fromLTRB(58, 9, 58, bottomInset + 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.13),
                    blurRadius: 18,
                    offset: const Offset(0, -7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SideNavItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Events',
                      selected: selectedIndex == 0,
                      onTap: () => onChanged(0),
                    ),
                  ),
                  const SizedBox(width: 94),
                  Expanded(
                    child: _SideNavItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      selected: selectedIndex == 2,
                      onTap: () => onChanged(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -2,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: selected
              ? AppColors.orangeGradient
              : const LinearGradient(colors: [AppColors.orange2, AppColors.orange]),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.22),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(Icons.mic_none_rounded, size: 38, color: Colors.white),
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
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: selected ? AppColors.royalBlue : AppColors.muted),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.royalBlue : AppColors.muted,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
