import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/radio_models.dart';

class Sun4UBackendData {
  const Sun4UBackendData({
    required this.config,
    required this.currentShow,
    required this.schedule,
    required this.podcasts,
    required this.events,
    required this.interests,
  });

  final AppConfig config;
  final RadioShow? currentShow;
  final List<RadioShow> schedule;
  final List<PodcastEpisode> podcasts;
  final List<CampusEvent> events;
  final List<String> interests;
}

class Sun4UBackendService {
  const Sun4UBackendService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<Sun4UBackendData> fetchAll() async {
    final results = await Future.wait<dynamic>([
      _client.from('app_config').select().eq('id', 'default').maybeSingle(),
      _client.from('radio_shows').select().eq('is_active', true).order('sort_order'),
      _client.from('podcast_episodes').select().eq('is_active', true).order('sort_order'),
      _client.from('campus_events').select().eq('is_active', true).order('sort_order'),
      _client.from('app_interests').select().eq('is_active', true).order('sort_order'),
    ]);

    final configRow = _asMap(results[0]);
    final showRows = _asMapList(results[1]);
    final podcastRows = _asMapList(results[2]);
    final eventRows = _asMapList(results[3]);
    final interestRows = _asMapList(results[4]);

    final config = AppConfig.fromMap(configRow ?? const <String, dynamic>{});
    final shows = showRows.map(RadioShow.fromMap).toList();
    final episodes = podcastRows.map(PodcastEpisode.fromMap).toList();
    final campusEvents = eventRows.map(CampusEvent.fromMap).toList();
    final interestLabels = interestRows
        .map((row) => row['label']?.toString().trim() ?? '')
        .where((label) => label.isNotEmpty)
        .toList();

    final liveShows = shows.where((show) => show.isLive);

    return Sun4UBackendData(
      config: config,
      currentShow: shows.isEmpty ? null : (liveShows.isNotEmpty ? liveShows.first : shows.first),
      schedule: shows,
      podcasts: episodes,
      events: campusEvents,
      interests: interestLabels,
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((key, data) => MapEntry(key.toString(), data));
    return null;
  }

  static List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((row) => row.map((key, data) => MapEntry(key.toString(), data)))
        .toList();
  }
}
