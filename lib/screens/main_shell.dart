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
    if (state == AppLifecycleState.resumed) loadSun4UDataFromSupabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: ValueListenableBuilder<int>(
        valueListenable: sun4UDataVersion,
        builder: (context, version, _) {
          return IndexedStack(
            index: _index,
            children: [
              EventsScreen(key: ValueKey('events_$version')),
              RadioScreen(key: ValueKey('home_$version')),
              SettingsScreen(key: ValueKey('settings_$version')),
            ],
          );
        },
      ),
      bottomNavigationBar: _Sun4UNavigationBar(
        selectedIndex: _index,
        onChanged: (value) => setState(() => _index = value),
      ),
    );
  }
}

class _Sun4UNavigationBar extends StatelessWidget {
  const _Sun4UNavigationBar({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      height: 76 + bottom,
      padding: EdgeInsets.only(bottom: bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 16, offset: const Offset(0, -3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.event_note_outlined,
              label: 'Events',
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _HomeNavItem(
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              selected: selectedIndex == 2,
              onTap: () => onChanged(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.orange : const Color(0xFFB0B0B0);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(Icons.home_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 1),
          Text(
            'Home',
            style: TextStyle(
              color: selected ? AppColors.orange : const Color(0xFF9F9F9F),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
