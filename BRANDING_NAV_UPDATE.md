# SUN4U bottom navigation + logo update

## What changed
- Bottom navigation now follows the supplied Figma/reference design:
  - white full-width bar
  - grey inactive Events/Settings items
  - orange active Events/Settings item
  - raised circular orange Home control with white outer ring
  - Home control remains visually prominent on every tab
- Replaced the text-built SUN4U logo with the supplied official PNG logo artwork.
- Added black, colour and white logo variants under `assets/branding/`.

## Required pubspec.yaml change
Add the following under your existing `flutter:` section:

```yaml
flutter:
  assets:
    - assets/branding/
```

If your `flutter:` section already contains `uses-material-design: true`, keep it. Example:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/branding/
```

Then run:

```bash
flutter clean
flutter pub get
```

## Files to copy into an existing project
Copy/replace:
- `lib/screens/main_shell.dart`
- `lib/widgets/app_logo.dart`
- `assets/branding/sun4u_logo_black.png`
- `assets/branding/sun4u_logo_colour.png`
- `assets/branding/sun4u_logo_white.png`

## Logo usage
Existing `AppLogo()` calls use the white logo by default, which is suitable for the current blue/orange/dark SUN4U screens.

For a light background:

```dart
const AppLogo(variant: AppLogoVariant.black)
```

For the coloured brand logo:

```dart
const AppLogo(variant: AppLogoVariant.colour)
```

For a custom width:

```dart
const AppLogo(
  variant: AppLogoVariant.colour,
  width: 140,
)
```
