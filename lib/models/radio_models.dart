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
}
