// Copyright (C) 2025 Mihaly Csaba
//
// This file is part of Farer Companion.
//
// Farer Companion is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Farer Companion is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Farer Companion.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'package:farer_companion/common/vars/globals.dart';
import 'package:farer_companion/common/vars/prefs.dart';
import 'package:farer_companion/views/companion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await Vibration.hasVibrator()) {
    hasVibrator = true;
  }

  prefs = await SharedPreferences.getInstance();

  if (prefs.getDouble(PrefsKeys.vibrateBefore.name) == null) {
    await prefs.setDouble(PrefsKeys.vibrateBefore.name, 10.0);
  }

  runApp(const FarerCompanion());
}

class FarerCompanion extends StatelessWidget {
  const FarerCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farer Companion',
      theme: _customTheme(),
      darkTheme: _customTheme(dark: true),
      home: const Companion(title: 'Farer Companion'),
    );
  }

  ThemeData _customTheme({bool dark = false}) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: dark ? Brightness.dark : Brightness.light,
        seedColor: const Color.fromARGB(255, 52, 5, 119),
      ),
      useMaterial3: true,
    );
  }
}
