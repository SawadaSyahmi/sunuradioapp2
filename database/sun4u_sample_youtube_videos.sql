-- SUN4U sample YouTube videos
-- Run after sun4u_ui_database_update.sql / production migration.
-- The app already knows how to play normal YouTube watch URLs in-app.

begin;

-- Ensure media columns exist on older databases.
alter table if exists public.podcast_episodes
  add column if not exists video_url text,
  add column if not exists media_type text,
  add column if not exists is_featured boolean not null default false,
  add column if not exists series_name text;

-- If you already have the Open Day Day 2 record, attach the official video
-- instead of creating a duplicate.
update public.podcast_episodes
set
  video_url = 'https://www.youtube.com/watch?v=YCc_WbzbGLM',
  media_type = 'video',
  series_name = coalesce(nullif(series_name, ''), 'Sun4U Open Day Special'),
  is_featured = true,
  image_url = case
    when coalesce(image_url, '') = '' then 'https://img.youtube.com/vi/YCc_WbzbGLM/hqdefault.jpg'
    else image_url
  end,
  hero_image_url = case
    when coalesce(hero_image_url, '') = '' then 'https://img.youtube.com/vi/YCc_WbzbGLM/hqdefault.jpg'
    else hero_image_url
  end
where lower(title) in (
  lower('Sun4U Open Day Special! (Day 2)'),
  lower('Sun4U Radio Open Day Special! (Day 2)')
);

-- Add the user-provided Sun4U Official sample video if it is not already in
-- the catalogue. This insert matches the columns already used by the app.
insert into public.podcast_episodes (
  title,
  host,
  duration_label,
  category,
  description,
  date_label,
  time_label,
  image_url,
  hero_image_url,
  video_url,
  media_type,
  series_name,
  status,
  is_featured,
  is_live,
  is_active,
  sort_order
)
select
  'Sun4U Official – Featured Video',
  'Sun4U Official',
  'Video',
  'Video',
  'Sample video from the Sun4U Official YouTube channel. Plays inside the SUN4U app.',
  'Sample video',
  '',
  'https://img.youtube.com/vi/GFNfPTjij9w/hqdefault.jpg',
  'https://img.youtube.com/vi/GFNfPTjij9w/hqdefault.jpg',
  'https://www.youtube.com/watch?v=GFNfPTjij9w',
  'video',
  'Sun4U Official',
  'passed',
  true,
  false,
  true,
  -20
where not exists (
  select 1
  from public.podcast_episodes
  where video_url = 'https://www.youtube.com/watch?v=GFNfPTjij9w'
);

-- If the Day 2 record did not already exist, create it as a sample row.
insert into public.podcast_episodes (
  title,
  host,
  duration_label,
  category,
  description,
  date_label,
  time_label,
  image_url,
  hero_image_url,
  video_url,
  media_type,
  series_name,
  status,
  is_featured,
  is_live,
  is_active,
  sort_order
)
select
  'Sun4U Open Day Special! (Day 2)',
  'Sun4U Official',
  'Video',
  'Open Day',
  'Sun4U Radio special broadcast for the Sunway University Open Day, featuring campus interviews and student voices.',
  '11 April 2026',
  '',
  'https://img.youtube.com/vi/YCc_WbzbGLM/hqdefault.jpg',
  'https://img.youtube.com/vi/YCc_WbzbGLM/hqdefault.jpg',
  'https://www.youtube.com/watch?v=YCc_WbzbGLM',
  'video',
  'Sun4U Open Day Special',
  'passed',
  false,
  false,
  true,
  -19
where not exists (
  select 1
  from public.podcast_episodes
  where video_url = 'https://www.youtube.com/watch?v=YCc_WbzbGLM'
);

commit;
