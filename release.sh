#!/bin/bash

flutter_version=$(flutter --version | cut -d' ' -f2 | head -n 1)
sed -i "s/Flutter version: \`[0-9.]\+\`/Flutter version: \`$flutter_version\`/g" ./README.md 
sed -i "/^  flutter: /c\  flutter: ^$flutter_version" pubspec.yaml

dart run flutter_oss_licenses:generate -o ./lib/views/misc/oss_licenses.dart
dart run vector_graphics_compiler -i assets/farer_companion_fg.svg -o assets/farer_companion_fg.svg.vec

dart fix --apply
dart format .

flutter build apk --release
flutter build windows --release
flutter build linux --release
flutter build web --release
