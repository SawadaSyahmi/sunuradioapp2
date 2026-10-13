# SUN4U Radio production security audit

## Fixed in this package

1. **Hard-coded Supabase key removed from Dart source**
   - `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` now come from Flutter build-time defines.
   - The publishable key is still visible inside a compiled mobile app by design; it is not treated as a secret.
   - No `service_role`/secret key may ever be placed in the app.

2. **Database access changed to least privilege**
   - Anonymous users: read active/public content only.
   - Authenticated non-admin users: same public read access.
   - Authenticated users listed in `sun4u_admin_users`: may create/update/delete content.
   - Existing policies on the content tables are removed by the production migration to prevent an old permissive policy from remaining active.

3. **Admin access model added**
   - Admin dashboard must use Supabase Auth.
   - Add each authorized staff member's Auth UUID to `public.sun4u_admin_users` from the Supabase SQL editor.
   - Do not restore anonymous insert/update/delete policies for convenience.

4. **HTTPS enforced in app code**
   - Live radio and direct video URLs must use HTTPS.
   - Android production manifest disables cleartext traffic.
   - iOS guidance keeps default App Transport Security; no arbitrary-load exception is added.

5. **Third-party test stream removed**
   - The BBC test stream is no longer a fallback. If the SUN4U stream is missing, playback fails safely instead of playing another station.

6. **Background audio production support added**
   - `just_audio_background` + `audio_service` metadata/notification support.
   - Android foreground media playback service configuration supplied.
   - iOS background audio mode supplied.

7. **Safer external links**
   - Settings links are opened only when they are HTTPS or `mailto:`.
   - Settings no longer merely prints URLs into a toast.

8. **Release logging reduced**
   - Detailed Supabase errors are printed only in debug builds.

9. **Scalability improvements**
   - Initial catalogue fetches are bounded.
   - Pagination helpers added for podcasts and events.
   - Database indexes added for active/status/start-time/featured queries.
   - Request timeout and a small retry are included for transient backend failures.

## Still requires account-side configuration

- Supabase Auth accounts for admins.
- Apply the SQL migration and add the first admin UUID.
- Ensure Data API exposes only the tables/functions the app actually uses.
- Store media in YouTube or object storage/CDN; do not store video/audio blobs in Postgres rows.
- Configure a real privacy policy URL and terms URL in `app_config`.
- Push notifications are intentionally disabled in the settings UI until FCM/APNs credentials and a push workflow are configured.
- Android upload signing key and Play Console account.
- Apple Developer account, distribution certificate/profile, App Store Connect record.
