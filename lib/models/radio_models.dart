class AppConfig {
  const AppConfig({
    required this.stationName,
    required this.stationSubtitle,
    required this.liveStreamUrl,
    required this.shareUrl,
    this.termsUrl = '',
    this.privacyUrl = '',
    this.contactUrl = '',
    this.instagramUrl = '',
    this.youtubeUrl = '',
    this.tiktokUrl = '',
    this.appVersion = '1.0.0',
  });

  final String stationName;
  final String stationSubtitle;
  final String liveStreamUrl;
  final String shareUrl;
  final String termsUrl;
  final String privacyUrl;
  final String contactUrl;
  final String instagramUrl;
  final String youtubeUrl;
  final String tiktokUrl;
  final String appVersion;

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    return AppConfig(
      stationName: _readString(map, ['station_name', 'stationName'], fallback: 'SUN4U Radio'),
      stationSubtitle: _readString(map, ['station_subtitle', 'stationSubtitle'], fallback: 'Campus radio, reimagined.'),
      liveStreamUrl: _readString(
        map,
        ['live_stream_url', 'liveStreamUrl'],
        fallback: '',
      ),
      shareUrl: _readString(map, ['share_url', 'shareUrl'], fallback: 'https://sunway.edu.my'),
      termsUrl: _readString(map, ['terms_url', 'termsUrl'], fallback: ''),
      privacyUrl: _readString(map, ['privacy_url', 'privacyUrl'], fallback: ''),
      contactUrl: _readString(map, ['contact_url', 'contactUrl'], fallback: ''),
      instagramUrl: _readString(map, ['instagram_url', 'instagramUrl'], fallback: ''),
      youtubeUrl: _readString(map, ['youtube_url', 'youtubeUrl'], fallback: ''),
      tiktokUrl: _readString(map, ['tiktok_url', 'tiktokUrl'], fallback: ''),
      appVersion: _readString(map, ['app_version', 'appVersion'], fallback: '1.0.0'),
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
    this.date = '',
    this.imageUrl = '',
    this.heroImageUrl = '',
    this.category = 'Live Show',
    this.seriesName = '',
    this.status = '',
    this.audioUrl = '',
    this.videoUrl = '',
    this.isFeatured = false,
    this.startAt,
    this.endAt,
  });

  final String title;
  final String host;
  final String time;
  final List<String> tags;
  final bool isLive;
  final String description;
  final String date;
  final String imageUrl;
  final String heroImageUrl;
  final String category;
  final String seriesName;
  final String status;
  final String audioUrl;
  final String videoUrl;
  final bool isFeatured;
  final DateTime? startAt;
  final DateTime? endAt;

  String get displayDateTime {
    if (date.trim().isEmpty) return time;
    if (time.trim().isEmpty) return date;
    return '$date | $time';
  }

  String get artworkUrl => heroImageUrl.trim().isNotEmpty ? heroImageUrl.trim() : imageUrl.trim();

  String get effectiveStatus {
    if (isLive) return 'live';
    final normalized = status.trim().toLowerCase();
    if (normalized == 'live' || normalized == 'passed' || normalized == 'past' || normalized == 'upcoming') {
      return normalized == 'past' ? 'passed' : normalized;
    }

    final now = DateTime.now();
    if (startAt != null) {
      if (endAt != null && now.isAfter(startAt!) && now.isBefore(endAt!)) return 'live';
      if (now.isBefore(startAt!)) return 'upcoming';
      if (endAt != null && now.isAfter(endAt!)) return 'passed';
    }

    final searchable = '${category.toLowerCase()} ${tags.join(' ').toLowerCase()}';
    if (searchable.contains('upcoming')) return 'upcoming';
    if (searchable.contains('live')) return 'live';
    return 'passed';
  }

  factory RadioShow.fromMap(Map<String, dynamic> map) {
    return RadioShow(
      title: _readString(map, ['title'], fallback: 'Untitled Show'),
      host: _readString(map, ['host', 'speaker', 'speaker_name'], fallback: 'SUN4U Team'),
      time: _readString(map, ['time_label', 'time', 'timeLabel'], fallback: 'TBA'),
      tags: _readStringList(map['tags']),
      isLive: map['is_live'] == true || map['isLive'] == true,
      description: _readString(map, ['description', 'summary'], fallback: ''),
      date: _readString(map, ['date_label', 'date', 'dateLabel'], fallback: ''),
      imageUrl: _readString(map, ['image_url', 'imageUrl', 'thumbnail_url', 'thumbnailUrl'], fallback: ''),
      heroImageUrl: _readString(map, ['hero_image_url', 'heroImageUrl', 'cover_url', 'coverUrl'], fallback: ''),
      category: _readString(map, ['category'], fallback: 'Live Show'),
      seriesName: _readString(map, ['series_name', 'seriesName'], fallback: ''),
      status: _readString(map, ['status'], fallback: ''),
      audioUrl: _readString(map, ['audio_url', 'audioUrl'], fallback: ''),
      videoUrl: _readString(map, ['video_url', 'videoUrl', 'youtube_url', 'youtubeUrl'], fallback: ''),
      isFeatured: map['is_featured'] == true || map['isFeatured'] == true,
      startAt: _readDateTime(map, ['starts_at', 'start_at', 'startAt']),
      endAt: _readDateTime(map, ['ends_at', 'end_at', 'endAt']),
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
    this.date = '',
    this.time = '',
    this.imageUrl = '',
    this.heroImageUrl = '',
    this.audioUrl = '',
    this.videoUrl = '',
    this.isLive = false,
    this.seriesName = '',
    this.status = '',
    this.mediaType = '',
    this.isFeatured = false,
    this.startAt,
    this.endAt,
  });

  final String title;
  final String host;
  final String duration;
  final String category;
  final String description;
  final String date;
  final String time;
  final String imageUrl;
  final String heroImageUrl;
  final String audioUrl;
  final String videoUrl;
  final bool isLive;
  final String seriesName;
  final String status;
  final String mediaType;
  final bool isFeatured;
  final DateTime? startAt;
  final DateTime? endAt;

  String get displayDateTime {
    final datePart = date.trim();
    final timePart = time.trim();
    if (datePart.isEmpty && timePart.isEmpty) return duration;
    if (datePart.isEmpty) return timePart;
    if (timePart.isEmpty) return datePart;
    return '$datePart | $timePart';
  }

  String get artworkUrl => heroImageUrl.trim().isNotEmpty ? heroImageUrl.trim() : imageUrl.trim();
  bool get hasVideo => videoUrl.trim().isNotEmpty;

  String get effectiveStatus {
    if (isLive) return 'live';
    final normalized = status.trim().toLowerCase();
    if (normalized == 'live' || normalized == 'passed' || normalized == 'past' || normalized == 'upcoming') {
      return normalized == 'past' ? 'passed' : normalized;
    }

    final now = DateTime.now();
    if (startAt != null) {
      if (endAt != null && now.isAfter(startAt!) && now.isBefore(endAt!)) return 'live';
      if (now.isBefore(startAt!)) return 'upcoming';
      if (endAt != null && now.isAfter(endAt!)) return 'passed';
    }

    final searchable = '$category $mediaType'.toLowerCase();
    if (searchable.contains('upcoming')) return 'upcoming';
    if (searchable.contains('live')) return 'live';
    return 'passed';
  }

  factory PodcastEpisode.fromMap(Map<String, dynamic> map) {
    return PodcastEpisode(
      title: _readString(map, ['title'], fallback: 'Untitled Episode'),
      host: _readString(map, ['host', 'speaker', 'speaker_name'], fallback: 'SUN4U Team'),
      duration: _readString(map, ['duration_label', 'duration', 'durationLabel'], fallback: '0 min'),
      category: _readString(map, ['category', 'episode_type', 'episodeType'], fallback: 'Podcast'),
      description: _readString(map, ['description', 'summary'], fallback: ''),
      date: _readString(map, ['date_label', 'date', 'dateLabel'], fallback: ''),
      time: _readString(map, ['time_label', 'time', 'timeLabel'], fallback: ''),
      imageUrl: _readString(map, ['image_url', 'imageUrl', 'thumbnail_url', 'thumbnailUrl'], fallback: ''),
      heroImageUrl: _readString(map, ['hero_image_url', 'heroImageUrl', 'cover_url', 'coverUrl'], fallback: ''),
      audioUrl: _readString(map, ['audio_url', 'audioUrl'], fallback: ''),
      videoUrl: _readString(map, ['video_url', 'videoUrl', 'youtube_url', 'youtubeUrl'], fallback: ''),
      isLive: map['is_live'] == true || map['isLive'] == true,
      seriesName: _readString(map, ['series_name', 'seriesName'], fallback: ''),
      status: _readString(map, ['status'], fallback: ''),
      mediaType: _readString(map, ['media_type', 'mediaType'], fallback: ''),
      isFeatured: map['is_featured'] == true || map['isFeatured'] == true,
      startAt: _readDateTime(map, ['starts_at', 'start_at', 'startAt']),
      endAt: _readDateTime(map, ['ends_at', 'end_at', 'endAt']),
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
    this.time = '',
    this.organiser = '',
    this.imageUrl = '',
    this.heroImageUrl = '',
    this.rsvpUrl = '',
    this.entry = 'Open to Sunway community',
    this.isFeatured = false,
    this.startAt,
    this.endAt,
  });

  final String title;
  final String date;
  final String venue;
  final String category;
  final String description;
  final String time;
  final String organiser;
  final String imageUrl;
  final String heroImageUrl;
  final String rsvpUrl;
  final String entry;
  final bool isFeatured;
  final DateTime? startAt;
  final DateTime? endAt;

  String get artworkUrl => heroImageUrl.trim().isNotEmpty ? heroImageUrl.trim() : imageUrl.trim();

  factory CampusEvent.fromMap(Map<String, dynamic> map) {
    return CampusEvent(
      title: _readString(map, ['title'], fallback: 'Untitled Event'),
      date: _readString(map, ['date_label', 'date', 'dateLabel'], fallback: 'TBA'),
      venue: _readString(map, ['venue'], fallback: 'Sunway University'),
      category: _readString(map, ['category'], fallback: 'Campus'),
      description: _readString(map, ['description', 'summary'], fallback: ''),
      time: _readString(map, ['time_label', 'time', 'timeLabel'], fallback: ''),
      organiser: _readString(map, ['organiser', 'organizer', 'host'], fallback: ''),
      imageUrl: _readString(map, ['image_url', 'imageUrl', 'thumbnail_url', 'thumbnailUrl'], fallback: ''),
      heroImageUrl: _readString(map, ['hero_image_url', 'heroImageUrl', 'cover_url', 'coverUrl'], fallback: ''),
      rsvpUrl: _readString(map, ['rsvp_url', 'rsvpUrl'], fallback: ''),
      entry: _readString(map, ['entry', 'participation'], fallback: 'Open to Sunway community'),
      isFeatured: map['is_featured'] == true || map['isFeatured'] == true,
      startAt: _readDateTime(map, ['starts_at', 'start_at', 'startAt']),
      endAt: _readDateTime(map, ['ends_at', 'end_at', 'endAt']),
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
  if (value is String && value.trim().isNotEmpty) {
    return value.split(',').map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }
  return const [];
}

DateTime? _readDateTime(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is DateTime) return value;
    if (value != null) {
      final parsed = DateTime.tryParse(value.toString());
      if (parsed != null) return parsed.toLocal();
    }
  }
  return null;
}
