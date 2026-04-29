import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/demo_data.dart';
import 'play_button.dart';

class SwipeUpDiscoverySheet extends StatefulWidget {
  const SwipeUpDiscoverySheet({super.key});

  @override
  State<SwipeUpDiscoverySheet> createState() => _SwipeUpDiscoverySheetState();
}

class _SwipeUpDiscoverySheetState extends State<SwipeUpDiscoverySheet> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  double _extent = .13;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _toggleSheet() async {
    final target = _extent < .2 ? .48 : (_extent < .78 ? 1.0 : .13);
    await _sheetController.animateTo(
      target,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if ((_extent - notification.extent).abs() > .001) {
          setState(() => _extent = notification.extent);
        }
        return true;
      },
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: .13,
        minChildSize: .13,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [.13, .48, 1.0],
        expand: false,
        builder: (context, scrollController) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xF2161026),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Colors.white.withOpacity(.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.35),
                  blurRadius: 28,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                InkWell(
                  onTap: _toggleSheet,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Column(
                      children: [
                        Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.18),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'UP NEXT',
                              style: TextStyle(
                                color: AppColors.dim,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .45,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                '10:00 AM  •  Design Critiques',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Icon(
                              _extent > .2 ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.white.withOpacity(.06)),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    children: [
                      Text(
                        currentShow.title,
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: .98),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Live now with ${currentShow.host}',
                        style: const TextStyle(color: AppColors.muted),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B29B5), Color(0xFF22133D)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white.withOpacity(.10)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.graphic_eq_rounded, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('LISTEN LIVE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800)),
                                  SizedBox(height: 4),
                                  Text('BBC stream is active for prototype testing', style: TextStyle(fontWeight: FontWeight.w800, height: 1.2)),
                                ],
                              ),
                            ),
                            const PlayButton(size: 42),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text('Discovery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              height: 160,
                              title: "Today's\nSchedule",
                              subtitle: '10:00 AM\nDesign Critiques\nSarah L.',
                              accent: AppColors.mint,
                              color: const Color(0xFF26143F),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 160,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2B1848),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0x66FFD75A)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "EDITOR'S PICK",
                                    style: TextStyle(color: Color(0xFFFFD85A), fontSize: 10, fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE2B04C),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(child: Icon(Icons.mic_none_rounded, color: Colors.white, size: 30)),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Mic Drop', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                                  const Text('Spoken Word', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Expanded(
                            child: _InfoCard(
                              height: 118,
                              title: 'Late Night\nStudy',
                              subtitle: 'Station',
                              color: Color(0xFF25153E),
                              accent: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _InfoCard(
                              height: 118,
                              title: 'Field Notes',
                              subtitle: 'Trending podcast',
                              color: Color(0xFF0D5D44),
                              accent: AppColors.mint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text('Upcoming Shows', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      ...schedule.skip(2).take(3).map(
                            (show) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(.08)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(show.time, style: const TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w800)),
                                        const SizedBox(height: 4),
                                        Text(show.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                                        Text(show.host, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('Remind'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.height,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.accent,
  });

  final double height;
  final String title;
  final String subtitle;
  final Color color;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final lines = subtitle.split('\n');
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, height: 1.0)),
          const Spacer(),
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == lines.length - 1 ? 0 : 3),
              child: Text(
                lines[i],
                style: TextStyle(
                  color: i == 0 ? accent : i == lines.length - 1 ? AppColors.muted : Colors.white,
                  fontSize: i == 1 ? 14 : 11,
                  fontWeight: i == 1 ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
