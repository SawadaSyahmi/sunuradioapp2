# SUN4U Radio — production deployment guide

This package is based on the latest SUN4U UI package and keeps the existing Flutter + Supabase architecture.

> Important: the uploaded project only contained the app `lib` source, not your full Flutter project (`pubspec.yaml`, `android/`, `ios/`). I therefore updated all Dart code directly and supplied exact production snippets/scripts for the platform files. Merge those snippets into the full project before building.

## 1. Replace the app source

Copy the `lib/` folder from this package into the Flutter project.

Add/resolve these dependencies (the project already used several of them):

```bash
flutter pub add supabase_flutter
flutter pub add just_audio
flutter pub add just_audio_background
flutter pub add audio_service
flutter pub add shared_preferences
flutter pub add video_player
flutter pub add youtube_player_flutter
flutter pub add url_launcher
flutter pub get
```

Do not blindly downgrade packages to match the example. Let your installed Flutter SDK resolve compatible versions, then test the lockfile.

## 2. Configure Supabase without committing environment values

Copy:

`deployment/env/prod.example.json` -> `deployment/env/prod.json`

Fill in:

```json
{
  "SUPABASE_URL": "https://YOUR_PROJECT_REF.supabase.co",
  "SUPABASE_PUBLISHABLE_KEY": "YOUR_PUBLISHABLE_KEY"
}
```

`prod.json` is git-ignored by the supplied additions.

A Supabase publishable/anon client key is not a secret that can be hidden inside a mobile binary. RLS is the actual security boundary. Never use the `service_role`/secret key in Flutter.

## 3. Apply the production database migration

Back up the project, then run:

`database/sun4u_production_security_scaling.sql`

This does four important things:

- enables/standardizes RLS on SUN4U content tables;
- makes anonymous/mobile access read-only and limited to active content;
- adds an authenticated-admin write policy;
- adds indexes used by the app and admin dashboard.

### Create the first admin

Create the staff account under Supabase Authentication. Copy its `auth.users.id`, then run this separately in SQL Editor:

```sql
insert into public.sun4u_admin_users(user_id)
values ('PUT-THE-AUTH-USER-UUID-HERE')
on conflict (user_id) do nothing;
```

Your existing web admin dashboard will need to sign in with Supabase Auth before editing records. Anonymous database writes should stay disabled.

## 4. Android production setup

Merge `deployment/android/AndroidManifest.production.snippet.xml` into your real manifest. Preserve your current application label, icons, theme, Flutter metadata and launch intent filter.

The important production items are:

- `INTERNET`
- `WAKE_LOCK`
- `FOREGROUND_SERVICE`
- `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
- AudioService service/receiver/activity
- `android:usesCleartextTraffic="false"`

Apply the `deployment/android/build.gradle.kts.production.snippet` concepts to your actual Gradle file. For September 2026 Google Play submission, use `compileSdk 36` and `targetSdk 36`.

### Signing

Generate and securely store an upload key. Do not put the JKS file or passwords in Git. Use `deployment/android/key.properties.example` only as a template.

Build:

```powershell
powershell -ExecutionPolicy Bypass -File deployment/build_android_release.ps1
```

Expected Play upload artifact:

`build/app/outputs/bundle/release/app-release.aab`

Keep `build/symbols/android` privately because the build script uses Dart obfuscation and those symbols are needed to decode stack traces.

## 5. iOS production setup

A Mac with Xcode is required for the final App Store build.

Merge the `UIBackgroundModes/audio` entry from `deployment/ios/Info.plist.production.snippet.xml` into `ios/Runner/Info.plist`.

Do **not** add `NSAllowsArbitraryLoads=true`; the app is intentionally HTTPS-only.

Set iOS deployment target to at least 13.0 using the supplied Podfile snippet and the Runner target in Xcode.

For current September 2026 App Store submission, build with Xcode 26 or newer and the iOS 26 SDK or newer.

Build on macOS:

```bash
./deployment/build_ios_release.sh
```

Then validate/archive in Xcode and upload through Organizer/App Store Connect.

## 6. Bundle/package IDs

Choose the final identifiers with the organization that owns the store accounts. Keep the same identifier permanently once published.

Examples of where to change them:

- Android: `applicationId` in `android/app/build.gradle(.kts)`
- iOS: Runner -> Signing & Capabilities -> Bundle Identifier

Do not publish under a personal identifier if the app is supposed to be institution-owned.

## 7. Production media behavior

- Live radio URL must be HTTPS.
- Direct video URLs must be HTTPS.
- YouTube URLs remain supported in the in-app player.
- Portrait video shows the SUN4U metadata layout.
- Landscape/full-screen uses a clean media-first layout.
- Returning from video restores portrait orientation for the main app.
- Background live audio supports lock-screen/media controls when the platform snippets are installed.

For scalability, prefer YouTube or Supabase Storage/object storage backed by CDN for images/audio/video. Keep only URLs and metadata in Postgres.

## 8. Scalable Supabase design

The present setup can comfortably support the app without introducing another backend if you follow these rules:

- keep public app queries read-only;
- authenticate admin-dashboard writers;
- keep RLS enabled on every Data API table;
- paginate long archive/event lists;
- query by indexed `starts_at`, `status`, `is_active`, `is_featured` fields;
- keep media outside Postgres;
- use image thumbnails rather than multi-megabyte originals in listing pages;
- avoid realtime subscriptions unless a screen truly needs them;
- add an Edge Function only for privileged server-side operations, email/push jobs, signed integrations or secrets.

Do not move ordinary catalogue reads to an Edge Function just to hide the publishable key. That adds latency and does not replace RLS.

## 9. Push notifications

The previous UI showed an "Allow notifications" switch without a real push backend. In this production package the control is disabled and labelled accordingly rather than pretending notifications are active.

When you are ready, add FCM for Android/APNs for iOS (commonly via Firebase Messaging or another provider), store device tokens securely, and send pushes from a trusted server/Edge Function — never from the mobile client with server credentials.

## 10. Store release checklist

Before submission:

- run the SQL migration and test anonymous read/admin write behavior;
- replace test/demo media with real SUN4U content;
- configure a real SUN4U live stream URL;
- configure Privacy Policy, Terms and Contact URLs;
- test airplane-mode/backend-failure behavior;
- test radio foreground/background/lock-screen controls;
- test YouTube and direct video in portrait and landscape;
- test on at least one physical Android device and one physical iPhone;
- run `flutter analyze` and `flutter test` with zero release-blocking errors;
- verify Android target API and App Bundle signing;
- verify iOS signing, capabilities and App Store archive validation;
- complete Google Play Data Safety and Apple App Privacy forms based on what the production build actually collects;
- complete current App Store age-rating questions;
- upload internal/TestFlight builds before production release.

## 11. What is intentionally not inside this package

No signing certificates, keystores, service-role keys, APNs keys, Firebase server credentials, passwords or private store credentials are included. Those must remain in secure organization-controlled storage.
