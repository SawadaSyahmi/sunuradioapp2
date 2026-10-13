import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../data/demo_data.dart';
import '../models/radio_models.dart';
import '../widgets/figma_media.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _query = '';
  String? _category;
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) {
    final featured = _featuredEvents();
    final filtered = _filteredEvents();

    return Container(
      color: AppColors.royalBlue,
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Events', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 18),
            if (featured.isNotEmpty) ...[
              SizedBox(
                height: 192,
                child: PageView.builder(
                  controller: PageController(viewportFraction: .91),
                  itemCount: featured.length,
                  itemBuilder: (context, index) {
                    final event = featured[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _EventHeroCard(event: event, onTap: () => _openEvent(event)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              const _DotsIndicator(),
              const SizedBox(height: 16),
            ],
            _SearchRow(
              onQueryChanged: (value) => setState(() => _query = value),
              onFilter: _openFilter,
            ),
            if (_category != null || _range != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  if (_category != null) _AppliedFilter(label: _category!),
                  if (_range != null) _AppliedFilter(label: '${_shortDate(_range!.start)} – ${_shortDate(_range!.end)}'),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white.withOpacity(.10), borderRadius: BorderRadius.circular(14)),
                child: const Text('No events match this filter.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
              )
            else
              for (final event in filtered)
                _EventListCard(event: event, onTap: () => _openEvent(event)),
          ],
        ),
      ),
    );
  }

  List<CampusEvent> _featuredEvents() {
    final preferred = events.where((event) => event.isFeatured).toList();
    return preferred.isNotEmpty ? preferred : events.take(4).toList();
  }

  List<CampusEvent> _filteredEvents() {
    final lowerQuery = _query.trim().toLowerCase();
    return events.where((event) {
      if (_category != null && event.category.toLowerCase() != _category!.toLowerCase()) return false;
      if (lowerQuery.isNotEmpty) {
        final haystack = '${event.title} ${event.category} ${event.organiser} ${event.venue}'.toLowerCase();
        if (!haystack.contains(lowerQuery)) return false;
      }
      if (_range != null && event.startAt != null) {
        final start = DateTime(_range!.start.year, _range!.start.month, _range!.start.day);
        final end = DateTime(_range!.end.year, _range!.end.month, _range!.end.day, 23, 59, 59);
        if (event.startAt!.isBefore(start) || event.startAt!.isAfter(end)) return false;
      }
      return true;
    }).toList();
  }

  void _openEvent(CampusEvent event) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)));
  }

  Future<void> _openFilter() async {
    final result = await showModalBottomSheet<_EventFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EventFilterSheet(initialCategory: _category, initialRange: _range),
    );
    if (result == null || !mounted) return;
    setState(() {
      _category = result.category;
      _range = result.range;
    });
  }
}

class _EventHeroCard extends StatelessWidget {
  const _EventHeroCard({required this.event, required this.onTap});

  final CampusEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: FigmaMedia(
          imageUrl: event.artworkUrl,
          title: event.title,
          category: event.category,
          icon: Icons.local_activity_rounded,
        ),
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.onQueryChanged, required this.onFilter});

  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onQueryChanged,
            style: const TextStyle(color: AppColors.navyText, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Search',
              suffixIcon: Icon(Icons.search_rounded),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: onFilter,
            icon: const Icon(Icons.tune_rounded, color: AppColors.royalBlue),
          ),
        ),
      ],
    );
  }
}

class _EventListCard extends StatelessWidget {
  const _EventListCard({required this.event, required this.onTap});

  final CampusEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(11)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 112,
              child: FigmaMedia(
                imageUrl: event.imageUrl,
                title: event.title,
                category: event.category,
                icon: Icons.local_activity_rounded,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.time.isEmpty ? event.date : '${event.date} | ${event.time}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.royalBlue, fontSize: 8),
                    ),
                    const Spacer(),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 15.5, height: .98, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'by ${event.organiser.isEmpty ? event.category : event.organiser}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.navyText, fontSize: 8),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: index == 0 ? 6 : 5,
          height: index == 0 ? 6 : 5,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: index == 0 ? AppColors.orange : Colors.white70),
        );
      }),
    );
  }
}

class _AppliedFilter extends StatelessWidget {
  const _AppliedFilter({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(color: AppColors.royalBlue, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

class _EventFilterResult {
  const _EventFilterResult({this.category, this.range});

  final String? category;
  final DateTimeRange? range;
}

class _EventFilterSheet extends StatefulWidget {
  const _EventFilterSheet({required this.initialCategory, required this.initialRange});

  final String? initialCategory;
  final DateTimeRange? initialRange;

  @override
  State<_EventFilterSheet> createState() => _EventFilterSheetState();
}

class _EventFilterSheetState extends State<_EventFilterSheet> {
  int _tab = 0;
  String? _category;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _range = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    final categories = events.map((event) => event.category).where((value) => value.trim().isNotEmpty).toSet().toList()..sort();
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 70, 16, 16),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _FilterTab(label: 'Date Range', active: _tab == 0, onTap: () => setState(() => _tab = 0)),
                const SizedBox(width: 26),
                _FilterTab(label: 'Category', active: _tab == 1, onTap: () => setState(() => _tab = 1)),
              ],
            ),
            const SizedBox(height: 18),
            if (_tab == 0)
              InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(now.year - 2),
                    lastDate: DateTime(now.year + 3),
                    initialDateRange: _range,
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.royalBlue),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _range = picked);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.royalBlue), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, color: AppColors.royalBlue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _range == null ? 'Select start and end date' : '${_shortDate(_range!.start)}  →  ${_shortDate(_range!.end)}',
                          style: const TextStyle(color: Color(0xFF555555), fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 310),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final item in categories)
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.royalBlue,
                        title: Text(item, style: const TextStyle(color: Color(0xFF666666), fontSize: 13)),
                        value: _category == item,
                        onChanged: (_) => setState(() => _category = _category == item ? null : item),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.royalBlue, side: const BorderSide(color: AppColors.royalBlue)),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _EventFilterResult(category: _category, range: _range)),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.royalBlue),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: active ? AppColors.royalBlue : Colors.transparent, width: 2))),
        child: Text(
          label,
          style: TextStyle(color: active ? AppColors.royalBlue : const Color(0xFFAAAAAA), fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

String _shortDate(DateTime date) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
}
