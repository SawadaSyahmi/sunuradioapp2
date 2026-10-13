# SUN4U Flutter Web YouTube Fix

## Error fixed

The previous YouTube screen used `youtube_player_flutter 9.1.3`, which instantiated `flutter_inappwebview` on Flutter Web and failed with:

```
UnimplementedError: addJavaScriptHandler is not implemented on the current platform
```

## Change

`lib/screens/video_player_screen.dart` now uses the already-included `youtube_player_iframe` package for YouTube videos.

- Works on Flutter Web, Android and iOS.
- Uses YouTube's iframe player.
- Keeps in-app playback.
- Supports the fullscreen button.
- Keeps portrait SUN4U metadata layout on normal browser windows.
- Allows landscape/fullscreen playback on phones/tablets.
- Direct HTTPS MP4/video URLs still use `video_player`.

The obsolete direct dependency on `youtube_player_flutter` was removed from `pubspec.yaml`.

## After copying the fix

Run:

```powershell
flutter clean
flutter pub get
flutter run -d chrome
```

Or, to force the production environment file:

```powershell
flutter run -d chrome --dart-define-from-file=deployment/env/prod.json
```

`flutter pub get` is important because it refreshes `pubspec.lock` and plugin registration after removing the old YouTube package.

## Expected console

Supabase should still report successful initialization and data loading. The previous `addJavaScriptHandler` exception should no longer appear when a YouTube video screen opens.
