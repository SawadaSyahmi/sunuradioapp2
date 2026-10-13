#!/usr/bin/env bash
set -euo pipefail
[ -f deployment/env/prod.json ] || { echo "Create deployment/env/prod.json first."; exit 1; }
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build ipa --release \
  --dart-define-from-file=deployment/env/prod.json \
  --obfuscate \
  --split-debug-info=build/symbols/ios
echo "IPA/archive output is under build/ios/archive and build/ios/ipa."
echo "KEEP build/symbols/ios securely for decoding crash traces."
