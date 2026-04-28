# SUN4U Radio Flutter Prototype

A Flutter implementation of the supplied SUN4U Radio mockup. This version focuses on matching the visual direction more closely: player-first home screen, dark purple/orange gradients, rounded glass cards, draggable discovery sheet, live timeline, mini player, and bottom navigation.

## Updated UI fidelity

- Home tab now opens directly into the immersive **player-first** screen, matching the main mockup direction.
- Swipe-up discovery sheet added under the player for the "Discovery Sheet" flow.
- Live tab redesigned as a schedule timeline with the current show highlighted.
- Onboarding remains guest-friendly with no compulsory sign-in step.
- Demo data restored to the mockup-style SUN4U content, while the audio stream still uses BBC World Service for testing.

## Included screens

- Splash / Welcome
- Tune-in value proposition
- Pick Interests
- All Set
- Home player-first hub
- Swipe-up Discovery Sheet
- Podcasts browse and episode detail
- Live schedule timeline
- Events with RSVP/reminder actions
- Profile, listening history, edit interests, sign out
- Live streaming controls with `just_audio`

## How to run

1. Extract this folder.
2. Open the folder in VS Code or Android Studio.
3. Run:

```bash
flutter create .
flutter pub get
flutter run
```

`flutter create .` generates the Android/iOS/Web platform folders around the provided `lib/` and `pubspec.yaml` files.

## Temporary live radio stream

The app is currently configured to play **BBC World Service** as a temporary test stream.

Open:

```text
lib/services/radio_player_controller.dart
```

Later, replace `kRadioStreamUrls` with the official SUN4U Radio streaming endpoint:

```dart
const kRadioStreamUrls = <String>[
  'https://your-sun4u-radio-stream-url-here',
];
```

## Design reference

The original screenshots are kept in `design_reference/` for comparison only. The app UI is rebuilt in Flutter using gradients, cards, chips, icons, and mock data.
