# SUN4U YouTube sample video update

This patch adds in-app YouTube playback samples to the existing production package.

## Included samples

1. User-provided Sun4U Official video:
   `https://www.youtube.com/watch?v=GFNfPTjij9w`
2. Sun4U Open Day Special! (Day 2):
   `https://www.youtube.com/watch?v=YCc_WbzbGLM`

The YouTube thumbnail is loaded using YouTube's standard HTTPS thumbnail URL, so no image file needs to be bundled in the app.

## Flutter changes

- `lib/data/demo_data.dart`
  - Adds both videos to offline/demo fallback data.
- `lib/screens/episode_detail_screen.dart`
  - Podcast video button now opens `AdaptiveVideoPlayerScreen`.
  - Tapping the video artwork also opens the player.
  - Portrait and landscape/full-screen behaviour remains supported.
- `lib/screens/podcasts_screen.dart`
  - Shows network thumbnails for video episodes.
  - Shows a play icon for video items.

## Supabase

Run:

`database/sun4u_sample_youtube_videos.sql`

in Supabase > SQL Editor.

The script avoids duplicate rows by checking `video_url`. It also updates an existing Open Day Day 2 row when one is already present.

## Adding more YouTube videos later

For any additional podcast/archive row, set:

- `video_url` = normal YouTube watch URL
- `media_type` = `video`
- `image_url` or `hero_image_url` = `https://img.youtube.com/vi/VIDEO_ID/hqdefault.jpg`
- `is_active` = `true`

No app update is needed for future videos; the Supabase catalogue drives the UI.
