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
            bottom: 110,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _index == 0
                    ? const SizedBox.shrink(key: ValueKey('no-mini-player'))
                    : MiniPlayer(
                        key: const ValueKey('mini-player'),
                        onOpenPlayer: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xEE080610),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(.09)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.45),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _NavItem(icon: Icons.home_rounded, label: 'Home', selected: _index == 0, onTap: () => _select(0))),
              Expanded(child: _NavItem(icon: Icons.headphones_rounded, label: 'Podcasts', selected: _index == 1, onTap: () => _select(1))),
              Expanded(child: _LiveNavItem(selected: _index == 2, onTap: () => _select(2))),
              Expanded(child: _NavItem(icon: Icons.calendar_month_rounded, label: 'Events', selected: _index == 3, onTap: () => _select(3))),
              Expanded(child: _NavItem(icon: Icons.person_rounded, label: 'Profile', selected: _index == 4, onTap: () => _select(4))),
            ],
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
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: double.infinity,
        decoration: BoxDecoration(
          color: selected ? AppColors.purple.withOpacity(.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : AppColors.dim, size: selected ? 23 : 21),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: selected ? 54 : 50,
            height: selected ? 54 : 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected ? AppColors.orangeGradient : null,
              color: selected ? null : const Color(0xFF141020),
              border: Border.all(color: Colors.white.withOpacity(selected ? .18 : .08)),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.orange.withOpacity(.32),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Icon(Icons.podcasts_rounded, color: selected ? Colors.white : AppColors.dim),
          ),
        ],
      ),
    );
  }
}
