# SUN4U Supabase startup fix

## Why the app showed demo data
The production refactor changed Supabase configuration to `String.fromEnvironment(...)`.
Running `flutter run` (or Run in the IDE) without `--dart-define` therefore produced empty values,
so `SupabaseConfig.isConfigured` was false and the app deliberately used local demo data.

## What is fixed
- Restored the project's previous PUBLIC Supabase client configuration as a fallback.
- Build-time `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, or `SUPABASE_ANON_KEY` still override the fallback.
- Added `deployment/env/prod.json` for local builds and IDE launch configurations.
- Added `deployment/run_web.ps1` and `deployment/build_web.ps1`.
- Fixed official logo asset path/declaration.
- Added Android INTERNET/background-audio configuration and iOS background audio mode.

## Run web
Normal run now works because the public fallback is present:

    flutter clean
    flutter pub get
    flutter run -d chrome

Preferred explicit configuration:

    flutter run -d chrome --dart-define-from-file=deployment/env/prod.json

Or on Windows:

    powershell -ExecutionPolicy Bypass -File deployment/run_web.ps1

## Build web for Firebase Hosting

    powershell -ExecutionPolicy Bypass -File deployment/build_web.ps1
    firebase deploy --only hosting

## Security
Only a Supabase PUBLIC client/anon key is present. Never add a service_role/secret key to Flutter.
RLS must remain enabled on the exposed tables.

## Console message clarification
`[WebPlatformInAppWebViewWidget] ... onWebViewCreated` is an informational web-view/player message, not the Supabase failure.
The meaningful message was `SUN4U Supabase is not configured. Using local demo data.`

## Startup query cleanup
`MainShell` now skips its immediate reload when the initial Supabase load already succeeded, avoiding a duplicate startup batch of database queries.
