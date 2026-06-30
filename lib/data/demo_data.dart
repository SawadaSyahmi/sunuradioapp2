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

const sun4UOpenDayDescription =
    'Live radio broadcast with Student Leadership Body (SLB) Representatives, featuring Sunway University Student Council (SUSC) Vice President Shereen Chang. She will be sharing insights into the council\'s behind-the-scenes work along with interesting stories from the university\'s highest student body.\n\nBesides that, the next session will feature sharing session with Sunway Student Ambassador (SSA) President Xuan Ni. She will discuss how SSA fosters bonds among scholarship students and contributes to initiatives that embody the concept of The Giving Sunwayians, giving back to the community.';

const fallbackCurrentShow = RadioShow(
  title: 'Sun4U Radio Open Day Special! (Day 2)',
  host: 'Student Leadership Body',
  date: '12 March 2026',
  time: '1hr 30mins',
  tags: ['Live', 'Open Day'],
  isLive: true,
  description: sun4UOpenDayDescription,
);

const fallbackSchedule = <RadioShow>[
  RadioShow(
    title: 'Sun4U Radio Open Day Special! (Day 1)',
    host: 'Student Leadership Body',
    date: '11 March 2026',
    time: '1hr 30mins',
    tags: ['Podcast'],
    description: sun4UOpenDayDescription,
  ),
  fallbackCurrentShow,
  RadioShow(
    title: 'Sun4U Radio Open Day Special! (Day 2)',
    host: 'Student Leadership Body',
    date: '12 Mar 2026',
    time: '02:00pm',
    tags: ['Live Show'],
    description: 'Live radio broadcast with Student Leadership Body Representatives.',
  ),
  RadioShow(
    title: 'Special Episode: The Game of Impossible',
    host: 'Prof. Dato\' Sri Idris Jala, Datuk Dr. Nicol David, and Leon Jala',
    date: '12 June 2026, Friday',
    time: '12:00PM',
    tags: ['Upcoming'],
    description: 'A special campus conversation on impossible goals, leadership, and resilience.',
  ),
  RadioShow(
    title: 'Cuppa Coffee EP10',
    host: 'Prof. Dato\' Elizabeth Lee',
    date: '19 June 2026, Friday',
    time: '12:00PM',
    tags: ['Upcoming'],
    description: 'A relaxed conversation over coffee with Sunway leaders and guests.',
  ),
  RadioShow(
    title: 'Emcee Workshop EP1',
    host: 'Sunway Student Experience Team',
    date: '23 June 2026, Tuesday',
    time: '12:00PM',
    tags: ['Upcoming'],
    description: 'A workshop recap for emcees and student hosts.',
  ),
];

const fallbackPodcasts = <PodcastEpisode>[
  PodcastEpisode(
    title: 'Sun4U Radio Open Day Special! (Day 1)',
    host: 'Student Leadership Body',
    date: '11 March 2026',
    duration: '1hr 30mins',
    category: 'Podcast',
    description: sun4UOpenDayDescription,
  ),
  PodcastEpisode(
    title: 'Sun4U Radio Open Day Special! (Day 2)',
    host: 'Student Leadership Body',
    date: '12 March 2026',
    duration: '1hr 30mins',
    category: 'Live',
    isLive: true,
    description: sun4UOpenDayDescription,
  ),
  PodcastEpisode(
    title: 'Special Episode: The Game of Impossible',
    host: 'Prof. Dato\' Sri Idris Jala, Datuk Dr. Nicol David, and Leon Jala',
    date: '12 June 2026, Friday',
    time: '12:00PM',
    duration: '50 min',
    category: 'Upcoming',
    description: 'A special campus conversation on impossible goals, leadership, and resilience.',
  ),
  PodcastEpisode(
    title: 'Cuppa Coffee EP10',
    host: 'Prof. Dato\' Elizabeth Lee',
    date: '19 June 2026, Friday',
    time: '12:00PM',
    duration: '45 min',
    category: 'Upcoming',
    description: 'A relaxed conversation over coffee with Sunway leaders and guests.',
  ),
  PodcastEpisode(
    title: 'Emcee Workshop EP1',
    host: 'Sunway Student Experience Team',
    date: '23 June 2026, Tuesday',
    time: '12:00PM',
    duration: '30 min',
    category: 'Upcoming',
    description: 'A workshop recap for emcees and student hosts.',
  ),
];

const fallbackEvents = <CampusEvent>[
  CampusEvent(
    title: 'Protect, Market, Create!',
    date: '19 June 2026, Friday',
    time: '10am-12pm',
    venue: 'Lecture Theatre 4, Sunway University Building',
    category: 'Creative Lecture Series',
    organiser: 'Faculty of Arts & Social Sciences',
    description:
        'Creative Lecture Series: "Protect, Market, Create! Essentials Insights for your Artistic Career" by Sophia Shung.\n\nDiscover essential copyright knowledge tailored for the design industry. Sophia Shung will guide you through protecting your creative work, marketing effectively, and building a sustainable artistic career. Learn practical insights that empower designers to safeguard originality, embrace professional ethics, and contribute meaningfully to the evolving creative landscape.\n\nFor more details, kindly refer to Ms Helen at heleng@sunway.edu.my',
    entry: 'Free of charge, open for all Sunway students',
  ),
  CampusEvent(
    title: 'The James Dyson Award Info Session',
    date: '18 June 2026, Thursday',
    venue: 'Sunway Innovation Labs',
    category: 'Info Session',
    organiser: 'Faculty of Engineering & Technology',
    description: 'An information session for students interested in the James Dyson Award and innovation design competitions.',
  ),
  CampusEvent(
    title: 'SUSC Elections Term 26/27',
    date: '3 June 2026, Wednesday',
    venue: 'Sunway University',
    category: 'Student Council',
    organiser: 'Sunway University Student Council',
    description: 'Student council election updates and available positions for the upcoming term.',
  ),
  CampusEvent(
    title: 'Grand Ticket Sales',
    date: '25 June 2026, Thursday',
    venue: 'Sunway Campus Boulevard',
    category: 'Campus',
    organiser: 'Sunway Student LIFE',
    description: 'Officially listed ticket sale announcement for selected campus activities.',
  ),
];

const fallbackInterests = <String>[
  'Music',
  'Campus',
  'Research',
  'Leadership',
  'Podcast',
  'Live Show',
  'Talk Show',
  'Events',
  'Creative',
  'Student Life',
  'Interviews',
  'Workshops',
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
