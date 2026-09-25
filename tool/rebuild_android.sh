#!/usr/bin/env bash
set -euo pipefail
flutter pub get
flutter create --platforms=android .
python3 - <<'PY'
from pathlib import Path
p = Path('android/app/src/main/AndroidManifest.xml')
s = p.read_text()
permissions = '''    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />\n    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />\n\n'''
if 'android.permission.ACCESS_FINE_LOCATION' not in s:
    s = s.replace('<application', permissions + '<application', 1)
p.write_text(s)
PY
echo 'Android project regenerated successfully.'
