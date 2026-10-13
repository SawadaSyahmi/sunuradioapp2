-- SUN4U Radio UI / media migration
-- Safe to run on an existing Supabase project. Existing columns/data are preserved.

begin;

-- -----------------------------------------------------------------------------
-- 1) App-level links/version used by the Settings screen
-- -----------------------------------------------------------------------------
alter table if exists public.app_config
  add column if not exists terms_url text,
  add column if not exists privacy_url text,
  add column if not exists contact_url text,
  add column if not exists instagram_url text,
  add column if not exists youtube_url text,
  add column if not exists tiktok_url text,
  add column if not exists app_version text default '1.0.0';

-- -----------------------------------------------------------------------------
-- 2) Program / live-radio metadata
-- status values expected by the app: passed | live | upcoming
-- starts_at / ends_at are preferred for automatic status/date filtering.
-- -----------------------------------------------------------------------------
alter table if exists public.radio_shows
  add column if not exists starts_at timestamptz,
  add column if not exists ends_at timestamptz,
  add column if not exists status text,
  add column if not exists series_name text,
  add column if not exists audio_url text,
  add column if not exists video_url text,
  add column if not exists is_featured boolean not null default false;

-- -----------------------------------------------------------------------------
-- 3) Podcast/archive media metadata
-- video_url can be a YouTube URL or a direct MP4/HLS-compatible URL supported
-- by your chosen Flutter video package. media_type is optional (video/audio).
-- -----------------------------------------------------------------------------
alter table if exists public.podcast_episodes
  add column if not exists starts_at timestamptz,
  add column if not exists ends_at timestamptz,
  add column if not exists status text,
  add column if not exists series_name text,
  add column if not exists media_type text,
  add column if not exists is_featured boolean not null default false,
  add column if not exists audio_url text,
  add column if not exists video_url text;

-- -----------------------------------------------------------------------------
-- 4) Events metadata for featured carousel and real date-range filtering
-- -----------------------------------------------------------------------------
alter table if exists public.campus_events
  add column if not exists starts_at timestamptz,
  add column if not exists ends_at timestamptz,
  add column if not exists is_featured boolean not null default false;

-- Helpful indexes for the admin dashboard / future server-side filters.
create index if not exists idx_radio_shows_starts_at on public.radio_shows (starts_at);
create index if not exists idx_radio_shows_status on public.radio_shows (status);
create index if not exists idx_podcast_episodes_starts_at on public.podcast_episodes (starts_at);
create index if not exists idx_podcast_episodes_status on public.podcast_episodes (status);
create index if not exists idx_campus_events_starts_at on public.campus_events (starts_at);

-- Keep old rows usable. The Flutter app can still fall back to date_label,
-- time_label, category, tags and is_live when these new fields are null.
update public.radio_shows
set status = case when is_live = true then 'live' else status end
where is_live = true and (status is null or btrim(status) = '');

update public.podcast_episodes
set status = case when is_live = true then 'live' else status end
where is_live = true and (status is null or btrim(status) = '');

-- Example configuration values. Replace with your actual SUN4U links.
update public.app_config
set app_version = coalesce(nullif(app_version, ''), '1.0.0')
where id = 'default';

commit;

-- -----------------------------------------------------------------------------
-- OPTIONAL EXAMPLES (edit IDs/timestamps/URLs before running)
-- -----------------------------------------------------------------------------
-- update public.podcast_episodes
-- set
--   status = 'passed',
--   series_name = 'Sunny Side Up Series',
--   starts_at = '2026-03-11 11:00:00+08',
--   ends_at = '2026-03-11 13:00:00+08',
--   video_url = 'https://www.youtube.com/watch?v=YOUR_VIDEO_ID',
--   media_type = 'video',
--   is_featured = true
-- where id = 'YOUR_EPISODE_ID';
--
-- update public.radio_shows
-- set
--   status = 'upcoming',
--   starts_at = '2026-09-30 10:00:00+08',
--   ends_at = '2026-09-30 12:00:00+08',
--   series_name = 'Sunny Side Up Series'
-- where id = 'YOUR_SHOW_ID';
--
-- update public.campus_events
-- set
--   starts_at = '2026-09-29 10:00:00+08',
--   ends_at = '2026-09-29 12:00:00+08',
--   is_featured = true
-- where id = 'YOUR_EVENT_ID';
