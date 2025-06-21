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

import 'package:farer_companion/common/vars/prefs.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: const Column(children: <Widget>[VibrationWidget()]),
    );
  }
}

class VibrationWidget extends StatefulWidget {
  const VibrationWidget({super.key});

  @override
  State<VibrationWidget> createState() => _VibrationWidgetState();
}

class _VibrationWidgetState extends State<VibrationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Vibrate before phase end'),
          DropdownButton<double>(
            value: prefs.getDouble(PrefsKeys.vibrateBefore.name) ?? 10.0,
            items: const [
              DropdownMenuItem(value: 0.0, child: Text('No vibration')),
              DropdownMenuItem(value: 5, child: Text('5 seconds')),
              DropdownMenuItem(value: 10, child: Text('10 seconds')),
              DropdownMenuItem(value: 15, child: Text('15 seconds')),
              DropdownMenuItem(value: 20, child: Text('20 seconds')),
            ],
            onChanged: (value) {
              if (value != null) {
                prefs.setDouble(PrefsKeys.vibrateBefore.name, value);
                setState(() {}); // Refresh the widget to reflect the change
              }
            },
          ),
        ],
      ),
    );
  }
}
