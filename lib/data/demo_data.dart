import '../models/radio_models.dart';

const currentShow = RadioShow(
  title: 'The Morning Buzz',
  host: 'Aiman & Priya',
  time: '8:00 AM – 10:00 AM',
  tags: ['Sociology', 'Talks'],
  isLive: true,
  description:
      'Player-first campus radio experience. Audio playback currently uses BBC World Service as a temporary test stream until the official SUN4U endpoint is ready.',
);

const schedule = <RadioShow>[
  RadioShow(title: 'Morning Mix', host: 'Auto-DJ', time: '6:00 AM', tags: ['Music']),
  currentShow,
  RadioShow(title: 'Design Critiques', host: 'Sarah L.', time: '10:00 AM – 12:00 PM', tags: ['Design', 'Lectures']),
  RadioShow(title: 'Indie Rock Hour', host: 'CMAT Radio', time: '12:00 PM – 2:00 PM', tags: ['Music', 'Indie Rock']),
  RadioShow(title: 'Faculty Files', host: 'Dr. Lim', time: '2:00 PM – 4:00 PM', tags: ['Research', 'Campus']),
  RadioShow(title: 'Late Night Study', host: 'Station Team', time: '10:00 PM', tags: ['Wellness', 'Station']),
];

const podcasts = <PodcastEpisode>[
  PodcastEpisode(
    title: 'Mic Drop: Spoken Word Special',
    host: 'Sunway Voices',
    duration: '18 min',
    category: 'Spoken Word',
    description:
        'Student poets share short reflections on identity, campus life, and creativity.',
  ),
  PodcastEpisode(
    title: 'Field Notes: Research Stories',
    host: 'FASS & FET Students',
    duration: '22 min',
    category: 'Research',
    description:
        'Quick student-friendly explainers on research projects happening around campus.',
  ),
  PodcastEpisode(
    title: 'Talks After Class',
    host: 'Daniel',
    duration: '31 min',
    category: 'Interviews',
    description:
        'Relaxed conversations with lecturers, alumni, and student societies after class.',
  ),
  PodcastEpisode(
    title: 'Late Night Study Beats',
    host: 'Station Team',
    duration: '45 min',
    category: 'Wellness',
    description:
        'A calming mix for revision nights, assignment pushes, and quiet campus walks.',
  ),
];

const events = <CampusEvent>[
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
];

const interests = <String>[
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
