import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/mini_player.dart';
import 'events_screen.dart';
import 'home_screen.dart';
import 'live_schedule_screen.dart';
import 'now_playing_screen.dart';
import 'podcasts_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    PodcastsScreen(),
    LiveScheduleScreen(),
    EventsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _screens),
          Positioned.fill(
            top: 0,
            left: 0,
            right: 0,
            bottom: 120,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MiniPlayer(
                      onOpenPlayer: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFF080610),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.08)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Home', selected: _index == 0, onTap: () => _select(0)),
                _NavItem(icon: Icons.headphones_rounded, label: 'Podcasts', selected: _index == 1, onTap: () => _select(1)),
                _LiveNavItem(selected: _index == 2, onTap: () => _select(2)),
                _NavItem(icon: Icons.calendar_month_rounded, label: 'Events', selected: _index == 3, onTap: () => _select(3)),
                _NavItem(icon: Icons.person_rounded, label: 'Profile', selected: _index == 4, onTap: () => _select(4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _select(int index) => setState(() => _index = index);
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? AppColors.purple : AppColors.dim, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.dim,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveNavItem extends StatelessWidget {
  const _LiveNavItem({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.purple.withOpacity(.35) : const Color(0xFF12101C),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Icon(Icons.podcasts_rounded, color: selected ? Colors.white : AppColors.dim),
      ),
    );
  }
}
