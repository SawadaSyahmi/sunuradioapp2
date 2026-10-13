$ErrorActionPreference = "Stop"
if (!(Test-Path "deployment/env/prod.json")) {
  throw "Create deployment/env/prod.json from prod.example.json first."
}
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release `
  --dart-define-from-file=deployment/env/prod.json `
  --obfuscate `
  --split-debug-info=build/symbols/android
Write-Host "AAB: build/app/outputs/bundle/release/app-release.aab"
Write-Host "KEEP build/symbols/android securely for decoding crash traces."
