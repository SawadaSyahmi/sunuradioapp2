$ErrorActionPreference = "Stop"
flutter pub get
flutter run -d chrome --dart-define-from-file=deployment/env/prod.json
