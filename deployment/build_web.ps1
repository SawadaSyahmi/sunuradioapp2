$ErrorActionPreference = "Stop"
flutter clean
flutter pub get
flutter analyze
flutter build web --release --dart-define-from-file=deployment/env/prod.json
Write-Host "Built: build/web"
Write-Host "Deploy with: firebase deploy --only hosting"
