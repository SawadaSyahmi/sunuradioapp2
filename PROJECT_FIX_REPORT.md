# SUN4U full-project fix report

## Root cause
`SupabaseConfig` had been changed to read only `String.fromEnvironment(...)` values. IDE/web launches that did not pass Dart defines therefore had empty Supabase URL/key values and intentionally fell back to demo data.

## Fixed
- Added the project's existing public Supabase client configuration as a safe fallback.
- Build-time config continues to override the fallback.
- Switched initialization to the current `publishableKey` argument.
- Added graceful Supabase initialization failure handling.
- Added working `deployment/env/prod.json` plus Web run/build PowerShell helpers.
- Added VS Code and Android Studio/IntelliJ launch configuration for Dart defines.
- Avoided a duplicate successful Supabase fetch when MainShell starts.
- Fixed branding assets from `assets/assets/branding` to `assets/branding` and declared them in `pubspec.yaml`.
- Updated web app title/manifest branding.
- Added Android INTERNET/background audio service configuration and disabled cleartext traffic.
- Changed MainActivity to AudioServiceActivity for background media controls.
- Added iOS background audio mode and SUN4U display name.

## Run
```powershell
flutter clean
flutter pub get
flutter run -d chrome
```

The normal command now works using the public project fallback.
For explicit build-time configuration:

```powershell
flutter run -d chrome --dart-define-from-file=deployment/env/prod.json
```

## Build web
```powershell
powershell -ExecutionPolicy Bypass -File deployment/build_web.ps1
firebase deploy --only hosting
```

## Still required before store release
- Replace `com.example.sunuradioapp2` with the institution-approved permanent Android/iOS identifier.
- Configure a real Android release upload keystore (the current release Gradle config still uses debug signing).
- Configure Apple Developer Team/signing in Xcode.
- Verify production RLS policies in Supabase before public release.
