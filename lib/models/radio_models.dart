class AppConfig {
  const AppConfig({
    required this.stationName,
    required this.stationSubtitle,
    required this.liveStreamUrl,
    required this.shareUrl,
  });

  final String stationName;
  final String stationSubtitle;
  final String liveStreamUrl;
  final String shareUrl;

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    return AppConfig(
      stationName: _readString(map, ['station_name', 'stationName'], fallback: 'SUN4U Radio'),
      stationSubtitle: _readString(map, ['station_subtitle', 'stationSubtitle'], fallback: 'Campus radio, reimagined.'),
      liveStreamUrl: _readString(
        map,
        ['live_stream_url', 'liveStreamUrl'],
        fallback: 'https://stream.live.vc.bbcmedia.co.uk/bbc_world_service',
      ),
      shareUrl: _readString(map, ['share_url', 'shareUrl'], fallback: 'https://sunway.edu.my'),
    );
  }
}

class RadioShow {
  const RadioShow({
    required this.title,
    required this.host,
    required this.time,
    required this.tags,
    this.isLive = false,
    this.description = '',
  });

  final String title;
  final String host;
  final String time;
  final List<String> tags;
  final bool isLive;
  final String description;

  factory RadioShow.fromMap(Map<String, dynamic> map) {
    return RadioShow(
      title: _readString(map, ['title'], fallback: 'Untitled Show'),
      host: _readString(map, ['host'], fallback: 'SUN4U Team'),
      time: _readString(map, ['time_label', 'time'], fallback: 'TBA'),
      tags: _readStringList(map['tags']),
      isLive: map['is_live'] == true || map['isLive'] == true,
      description: _readString(map, ['description'], fallback: ''),
    );
  }
}

class PodcastEpisode {
  const PodcastEpisode({
    required this.title,
    required this.host,
    required this.duration,
    required this.category,
    required this.description,
  });

  final String title;
  final String host;
  final String duration;
  final String category;
  final String description;

  factory PodcastEpisode.fromMap(Map<String, dynamic> map) {
    return PodcastEpisode(
      title: _readString(map, ['title'], fallback: 'Untitled Episode'),
      host: _readString(map, ['host'], fallback: 'SUN4U Team'),
      duration: _readString(map, ['duration_label', 'duration'], fallback: '0 min'),
      category: _readString(map, ['category'], fallback: 'Podcast'),
      description: _readString(map, ['description'], fallback: ''),
    );
  }
}

class CampusEvent {
  const CampusEvent({
    required this.title,
    required this.date,
    required this.venue,
    required this.category,
    required this.description,
  });

  final String title;
  final String date;
  final String venue;
  final String category;
  final String description;

  factory CampusEvent.fromMap(Map<String, dynamic> map) {
    return CampusEvent(
      title: _readString(map, ['title'], fallback: 'Untitled Event'),
      date: _readString(map, ['date_label', 'date'], fallback: 'TBA'),
      venue: _readString(map, ['venue'], fallback: 'Sunway University'),
      category: _readString(map, ['category'], fallback: 'Campus'),
      description: _readString(map, ['description'], fallback: ''),
    );
  }
}

String _readString(Map<String, dynamic> map, List<String> keys, {required String fallback}) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value != null && value.toString().trim().isNotEmpty) return value.toString().trim();
  }
  return fallback;
}

List<String> _readStringList(dynamic value) {
  if (value is List) return value.map((item) => item.toString()).where((item) => item.trim().isNotEmpty).toList();
  if (value is String && value.trim().isNotEmpty) return value.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  return const [];
}
