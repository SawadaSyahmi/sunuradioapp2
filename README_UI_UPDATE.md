# SUN4U Radio UI update

This package updates the Flutter `lib/` UI to follow the supplied SUN4U Figma/screenshots more closely:

- Landing/Home with large featured media, current live-radio card and an orange draggable program-listing panel.
- Previous / Upcoming program listing with working search and Date Range / Category filters.
- Events page with blue SUN4U styling, featured carousel, search and filters.
- Simplified Settings page matching the supplied layout (Permissions, About Us, Join Community, version).
- Program detail screen with Archive / Live / Upcoming treatment and video action.
- Adaptive in-app video screen:
  - portrait: video + program information;
  - landscape: clean full-width player;
  - YouTube URLs use `youtube_player_flutter`;
  - direct video URLs use `video_player`.
- Database model additions for typed timestamps, program status, series name, featured content and media URLs.

## Required Flutter packages

The uploaded ZIP only contained `lib/`, so `pubspec.yaml` was not available to edit. From the root of your Flutter project run:

```bash
flutter pub add video_player
flutter pub add youtube_player_flutter
flutter pub get
```

Your existing project already uses packages such as `supabase_flutter`, `just_audio`, and `device_preview`.

## Database

Run `sun4u_ui_database_update.sql` once in **Supabase > SQL Editor**.

For the best filtering and automatic program state, fill these fields from the admin dashboard:

- `starts_at`, `ends_at` (real timestamps)
- `status`: `passed`, `live`, or `upcoming`
- `series_name`
- `is_featured`
- `video_url` for archived/video programs

Old `date_label`, `time_label`, `category`, `tags`, and `is_live` values remain supported, so existing rows do not need to be recreated.

## YouTube videos

Store the normal YouTube URL directly in `podcast_episodes.video_url`, for example:

```text
https://www.youtube.com/watch?v=VIDEO_ID
```

The app detects YouTube automatically and keeps playback inside the app.

## Portrait + landscape

The player code supports both orientations. Also make sure the native app is not locked to portrait:

- Android: do not force `android:screenOrientation="portrait"` on `MainActivity`.
- iOS: keep both portrait and landscape orientations enabled in the Runner target / `Info.plist`.

The direct-video full-screen button temporarily switches to landscape and restores normal orientation when leaving the player.
