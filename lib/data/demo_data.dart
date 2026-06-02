import 'package:flutter/foundation.dart';

import '../models/radio_models.dart';
import '../services/sun4u_backend_service.dart';
import '../services/supabase_config.dart';

const fallbackAppConfig = AppConfig(
  stationName: 'SUN4U Radio',
  stationSubtitle: 'Campus radio, reimagined.',
  liveStreamUrl: 'https://stream.live.vc.bbcmedia.co.uk/bbc_world_service',
  shareUrl: 'https://sunway.edu.my',
);

const fallbackCurrentShow = RadioShow(
  title: 'The Morning Buzz',
  host: 'Aiman & Priya',
  time: '8:00 AM – 10:00 AM',
  tags: ['Sociology', 'Talks'],
  isLive: true,
  description:
      'Player-first campus radio experience. Audio playback currently uses BBC World Service as a temporary test stream until the official SUN4U endpoint is ready.',
);

const fallbackSchedule = <RadioShow>[
  RadioShow(title: 'Morning Mix', host: 'Auto-DJ', time: '6:00 AM', tags: ['Music']),
  fallbackCurrentShow,
  RadioShow(title: 'Design Critiques', host: 'Sarah L.', time: '10:00 AM – 12:00 PM', tags: ['Design', 'Lectures']),
  RadioShow(title: 'Indie Rock Hour', host: 'CMAT Radio', time: '12:00 PM – 2:00 PM', tags: ['Music', 'Indie Rock']),
  RadioShow(title: 'Faculty Files', host: 'Dr. Lim', time: '2:00 PM – 4:00 PM', tags: ['Research', 'Campus']),
  RadioShow(title: 'Student Voices Live', host: 'Nadia & Jason', time: '5:00 PM – 6:00 PM', tags: ['Campus', 'Talks']),
  RadioShow(title: 'Late Night Study', host: 'Station Team', time: '10:00 PM', tags: ['Wellness', 'Station']),
];

const fallbackPodcasts = <PodcastEpisode>[
  PodcastEpisode(
    title: 'Mic Drop: Spoken Word Special',
    host: 'Sunway Voices',
    duration: '18 min',
    category: 'Spoken Word',
    description: 'Student poets share short reflections on identity, campus life, and creativity.',
  ),
  PodcastEpisode(
    title: 'Field Notes: Research Stories',
    host: 'FASS & FET Students',
    duration: '22 min',
    category: 'Research',
    description: 'Quick student-friendly explainers on research projects happening around campus.',
  ),
  PodcastEpisode(
    title: 'Talks After Class',
    host: 'Daniel',
    duration: '31 min',
    category: 'Interviews',
    description: 'Relaxed conversations with lecturers, alumni, and student societies after class.',
  ),
  PodcastEpisode(
    title: 'Late Night Study Beats',
    host: 'Station Team',
    duration: '45 min',
    category: 'Wellness',
    description: 'A calming mix for revision nights, assignment pushes, and quiet campus walks.',
  ),
  PodcastEpisode(
    title: 'Campus Makers',
    host: 'Innovation Club',
    duration: '28 min',
    category: 'Research',
    description: 'Stories from students building apps, robots, digital media projects, and creative prototypes.',
  ),
];

const fallbackEvents = <CampusEvent>[
  CampusEvent(
    title: 'EYMF 2026',
    date: '20 Apr',
    venue: 'Eurasia Youth Music',
    category: 'Music',
    description: 'A live student showcase featuring bands, soloists, and campus performers.',
  ),
  CampusEvent(
    title: 'Souls Out',
    date: '2 May',
    venue: 'CMAT Showcase',
    category: 'Showcase',
    description: 'A late afternoon showcase for original songs and acoustic performances.',
  ),
  CampusEvent(
    title: 'Podcast Open Mic',
    date: '9 May',
    venue: 'Library Studio',
    category: 'Podcast',
    description: 'Try a 5-minute podcast segment and get feedback from the station crew.',
  ),
  CampusEvent(
    title: 'FASS Culture Night',
    date: '18 May',
    venue: 'Sunway University Hall',
    category: 'Showcase',
    description: 'An evening of stories, performances, and student-led cultural highlights.',
  ),
];

const fallbackInterests = <String>[
  'Music',
  'Indie Rock',
  'Sociology',
  'Design',
  'Research',
  'Industry',
  'Spoken Word',
  'Lectures',
  'Interviews',
  'Podcasts',
  'Events',
  'Talks',
  'Comedy',
  'Wellness',
];

AppConfig appConfig = fallbackAppConfig;
RadioShow currentShow = fallbackCurrentShow;
List<RadioShow> schedule = List<RadioShow>.of(fallbackSchedule);
List<PodcastEpisode> podcasts = List<PodcastEpisode>.of(fallbackPodcasts);
List<CampusEvent> events = List<CampusEvent>.of(fallbackEvents);
List<String> interests = List<String>.of(fallbackInterests);

final ValueNotifier<int> sun4UDataVersion = ValueNotifier<int>(0);
bool sun4ULoadedFromSupabase = false;
String? sun4ULastLoadError;

Future<bool> loadSun4UDataFromSupabase({bool notify = true}) async {
  if (!SupabaseConfig.isConfigured) {
    sun4ULoadedFromSupabase = false;
    sun4ULastLoadError = 'Supabase is not configured. Check SupabaseConfig.url and anonKey.';
    debugPrint('SUN4U Supabase is not configured. Using local demo data.');
    if (notify) sun4UDataVersion.value++;
    return false;
  }

  try {
    final remote = await Sun4UBackendService.fetchAll();
    appConfig = remote.config;
    if (remote.schedule.isNotEmpty) {
      schedule = remote.schedule;
    }
    if (remote.currentShow != null) {
      currentShow = remote.currentShow!;
    }
    if (remote.podcasts.isNotEmpty) podcasts = remote.podcasts;
    if (remote.events.isNotEmpty) events = remote.events;
    if (remote.interests.isNotEmpty) interests = remote.interests;
    sun4ULoadedFromSupabase = true;
    sun4ULastLoadError = null;
    if (notify) sun4UDataVersion.value++;
    debugPrint('SUN4U Supabase data loaded: ${schedule.length} shows, ${podcasts.length} podcasts, ${events.length} events.');
    return true;
  } on Object catch (error, stackTrace) {
    sun4ULoadedFromSupabase = false;
    sun4ULastLoadError = error.toString();
    debugPrint('Failed to load SUN4U Supabase data: $error');
    debugPrint('$stackTrace');
    if (notify) sun4UDataVersion.value++;
    return false;
  }
}
