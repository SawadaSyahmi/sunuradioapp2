-- SUN4U Radio production security + scaling migration
-- Run in Supabase SQL Editor AFTER taking a backup.
-- This intentionally makes the public mobile client READ-ONLY.
-- Your admin dashboard must sign in with Supabase Auth before it can write.

begin;

-- -----------------------------------------------------------------------------
-- 1) Admin allow-list. Bootstrap admins from SQL Editor after this migration.
-- -----------------------------------------------------------------------------
create table if not exists public.sun4u_admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.sun4u_admin_users enable row level security;
revoke all on table public.sun4u_admin_users from anon, authenticated;
grant select on table public.sun4u_admin_users to authenticated;

-- Users may only see whether their own account is listed.
drop policy if exists sun4u_admin_read_self on public.sun4u_admin_users;
create policy sun4u_admin_read_self
on public.sun4u_admin_users
for select
to authenticated
using (user_id = auth.uid());

-- Security-definer helper avoids policy recursion when content policies check admin status.
create or replace function public.is_sun4u_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.sun4u_admin_users a
    where a.user_id = auth.uid()
  );
$$;

revoke all on function public.is_sun4u_admin() from public;
grant execute on function public.is_sun4u_admin() to anon, authenticated;

-- -----------------------------------------------------------------------------
-- 2) Ensure columns used by the production UI exist.
-- -----------------------------------------------------------------------------
alter table if exists public.app_config
  add column if not exists terms_url text,
  add column if not exists privacy_url text,
  add column if not exists contact_url text,
  add column if not exists instagram_url text,
  add column if not exists youtube_url text,
  add column if not exists tiktok_url text,
  add column if not exists app_version text default '1.0.0',
  add column if not exists updated_at timestamptz not null default now();

alter table if exists public.radio_shows
  add column if not exists starts_at timestamptz,
  add column if not exists ends_at timestamptz,
  add column if not exists status text,
  add column if not exists series_name text,
  add column if not exists audio_url text,
  add column if not exists video_url text,
  add column if not exists is_featured boolean not null default false,
  add column if not exists updated_at timestamptz not null default now();

alter table if exists public.podcast_episodes
  add column if not exists starts_at timestamptz,
  add column if not exists ends_at timestamptz,
  add column if not exists status text,
  add column if not exists series_name text,
  add column if not exists media_type text,
  add column if not exists is_featured boolean not null default false,
  add column if not exists audio_url text,
  add column if not exists video_url text,
  add column if not exists updated_at timestamptz not null default now();

alter table if exists public.campus_events
  add column if not exists starts_at timestamptz,
  add column if not exists ends_at timestamptz,
  add column if not exists is_featured boolean not null default false,
  add column if not exists updated_at timestamptz not null default now();

alter table if exists public.app_interests
  add column if not exists updated_at timestamptz not null default now();

-- -----------------------------------------------------------------------------
-- 3) Keep updated_at current automatically.
-- -----------------------------------------------------------------------------
create or replace function public.sun4u_set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Recreate triggers safely.
drop trigger if exists trg_sun4u_app_config_updated_at on public.app_config;
create trigger trg_sun4u_app_config_updated_at before update on public.app_config
for each row execute function public.sun4u_set_updated_at();

drop trigger if exists trg_sun4u_radio_shows_updated_at on public.radio_shows;
create trigger trg_sun4u_radio_shows_updated_at before update on public.radio_shows
for each row execute function public.sun4u_set_updated_at();

drop trigger if exists trg_sun4u_podcast_episodes_updated_at on public.podcast_episodes;
create trigger trg_sun4u_podcast_episodes_updated_at before update on public.podcast_episodes
for each row execute function public.sun4u_set_updated_at();

drop trigger if exists trg_sun4u_campus_events_updated_at on public.campus_events;
create trigger trg_sun4u_campus_events_updated_at before update on public.campus_events
for each row execute function public.sun4u_set_updated_at();

drop trigger if exists trg_sun4u_app_interests_updated_at on public.app_interests;
create trigger trg_sun4u_app_interests_updated_at before update on public.app_interests
for each row execute function public.sun4u_set_updated_at();

-- -----------------------------------------------------------------------------
-- 4) Least-privilege grants. Anonymous/public app can only SELECT.
-- Authenticated users may only write when RLS confirms they are an admin.
-- -----------------------------------------------------------------------------
do $$
declare
  t text;
begin
  foreach t in array array['app_config','radio_shows','podcast_episodes','campus_events','app_interests']
  loop
    if to_regclass('public.' || t) is not null then
      execute format('alter table public.%I enable row level security', t);
      execute format('revoke all on table public.%I from anon, authenticated', t);
      execute format('grant select on table public.%I to anon, authenticated', t);
      execute format('grant insert, update, delete on table public.%I to authenticated', t);
    end if;
  end loop;
end $$;

-- Drop all existing policies on the five public-content tables.
do $$
declare
  p record;
begin
  for p in
    select schemaname, tablename, policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = any(array['app_config','radio_shows','podcast_episodes','campus_events','app_interests'])
  loop
    execute format('drop policy if exists %I on %I.%I', p.policyname, p.schemaname, p.tablename);
  end loop;
end $$;

-- Public reads: only active/published content.
create policy sun4u_public_read_config
on public.app_config for select
to anon, authenticated
using (id = 'default' or public.is_sun4u_admin());

create policy sun4u_public_read_radio
on public.radio_shows for select
to anon, authenticated
using (is_active = true or public.is_sun4u_admin());

create policy sun4u_public_read_podcasts
on public.podcast_episodes for select
to anon, authenticated
using (is_active = true or public.is_sun4u_admin());

create policy sun4u_public_read_events
on public.campus_events for select
to anon, authenticated
using (is_active = true or public.is_sun4u_admin());

create policy sun4u_public_read_interests
on public.app_interests for select
to anon, authenticated
using (is_active = true or public.is_sun4u_admin());

-- Admin writes.
create policy sun4u_admin_write_config
on public.app_config for all
to authenticated
using (public.is_sun4u_admin())
with check (public.is_sun4u_admin());

create policy sun4u_admin_write_radio
on public.radio_shows for all
to authenticated
using (public.is_sun4u_admin())
with check (public.is_sun4u_admin());

create policy sun4u_admin_write_podcasts
on public.podcast_episodes for all
to authenticated
using (public.is_sun4u_admin())
with check (public.is_sun4u_admin());

create policy sun4u_admin_write_events
on public.campus_events for all
to authenticated
using (public.is_sun4u_admin())
with check (public.is_sun4u_admin());

create policy sun4u_admin_write_interests
on public.app_interests for all
to authenticated
using (public.is_sun4u_admin())
with check (public.is_sun4u_admin());

-- -----------------------------------------------------------------------------
-- 5) Indexes for common mobile/admin queries.
-- -----------------------------------------------------------------------------
create index if not exists idx_radio_active_sort on public.radio_shows (is_active, sort_order);
create index if not exists idx_radio_active_start on public.radio_shows (is_active, starts_at desc);
create index if not exists idx_radio_active_status on public.radio_shows (is_active, status);
create index if not exists idx_radio_featured on public.radio_shows (is_featured) where is_active = true;

create index if not exists idx_podcast_active_sort on public.podcast_episodes (is_active, sort_order);
create index if not exists idx_podcast_active_start on public.podcast_episodes (is_active, starts_at desc);
create index if not exists idx_podcast_active_status on public.podcast_episodes (is_active, status);
create index if not exists idx_podcast_featured on public.podcast_episodes (is_featured) where is_active = true;

create index if not exists idx_event_active_sort on public.campus_events (is_active, sort_order);
create index if not exists idx_event_active_start on public.campus_events (is_active, starts_at);
create index if not exists idx_event_featured on public.campus_events (is_featured) where is_active = true;

create index if not exists idx_interest_active_sort on public.app_interests (is_active, sort_order);

-- Normalize current live rows without deleting existing data.
update public.radio_shows
set status = 'live'
where is_live = true and (status is null or btrim(status) = '');

update public.podcast_episodes
set status = 'live'
where is_live = true and (status is null or btrim(status) = '');

commit;

-- -----------------------------------------------------------------------------
-- BOOTSTRAP ONE ADMIN (run separately in SQL Editor after creating the Auth user)
-- Replace the UUID with the user's auth.users.id.
-- -----------------------------------------------------------------------------
-- insert into public.sun4u_admin_users(user_id)
-- values ('00000000-0000-0000-0000-000000000000')
-- on conflict (user_id) do nothing;
