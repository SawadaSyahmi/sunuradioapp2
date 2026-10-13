import 'dart:async';

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
  static const Duration _requestTimeout = Duration(seconds: 15);

  /// Initial payload is intentionally bounded. As content grows, screens can use
  /// the paginated methods below instead of downloading the entire catalogue.
  static Future<Sun4UBackendData> fetchAll() async {
    return _retry(() async {
      final results = await Future.wait<dynamic>([
        _client.from('app_config').select().eq('id', 'default').maybeSingle(),
        _client.from('radio_shows').select().eq('is_active', true).order('sort_order').limit(250),
        _client.from('podcast_episodes').select().eq('is_active', true).order('sort_order').limit(120),
        _client.from('campus_events').select().eq('is_active', true).order('sort_order').limit(120),
        _client.from('app_interests').select().eq('is_active', true).order('sort_order').limit(100),
      ]).timeout(_requestTimeout);

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

      final liveShows = shows.where((show) => show.effectiveStatus == 'live');

      return Sun4UBackendData(
        config: config,
        currentShow: shows.isEmpty ? null : (liveShows.isNotEmpty ? liveShows.first : shows.first),
        schedule: shows,
        podcasts: episodes,
        events: campusEvents,
        interests: interestLabels,
      );
    });
  }

  static Future<List<PodcastEpisode>> fetchPodcastPage({int page = 0, int pageSize = 30}) async {
    final safeSize = pageSize.clamp(1, 100).toInt();
    final from = page * safeSize;
    final to = from + safeSize - 1;
    final rows = await _retry(
      () => _client
          .from('podcast_episodes')
          .select()
          .eq('is_active', true)
          .order('starts_at', ascending: false, nullsFirst: false)
          .range(from, to)
          .timeout(_requestTimeout),
    );
    return _asMapList(rows).map(PodcastEpisode.fromMap).toList();
  }

  static Future<List<CampusEvent>> fetchEventPage({int page = 0, int pageSize = 30}) async {
    final safeSize = pageSize.clamp(1, 100).toInt();
    final from = page * safeSize;
    final to = from + safeSize - 1;
    final rows = await _retry(
      () => _client
          .from('campus_events')
          .select()
          .eq('is_active', true)
          .order('starts_at', ascending: true, nullsFirst: false)
          .range(from, to)
          .timeout(_requestTimeout),
    );
    return _asMapList(rows).map(CampusEvent.fromMap).toList();
  }

  static Future<T> _retry<T>(Future<T> Function() operation) async {
    Object? lastError;
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        return await operation();
      } on TimeoutException catch (error) {
        lastError = error;
      } on PostgrestException catch (error) {
        lastError = error;
        if (error.code != null && !error.code!.startsWith('5')) rethrow;
      }
      if (attempt == 0) {
        await Future<void>.delayed(const Duration(milliseconds: 350));
      }
    }
    throw lastError ?? StateError('Unknown backend error');
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
