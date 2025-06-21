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

import 'package:farer_companion/common/vars/globals.dart';
import 'package:farer_companion/nav/custom_nav.dart';
import 'package:farer_companion/views/misc/about.dart';
import 'package:farer_companion/views/settings.dart';
import 'package:farer_companion/views/timer.dart';

class Companion extends StatelessWidget {
  const Companion({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          hasVibrator
              ? IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: () => customNav(const Settings(), context),
                )
              : Container(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 30,
              child: Text(
                'Welcome to Farer Companion!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const Expanded(
              flex: 12,
              child: Center(
                child: Text(
                  '    Press the button when\nthe day animation appears',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Flexible(
              flex: 30,
              child: FilledButton(
                onPressed: () => customNav(const Counter(), context),
                child: const Text('Start', style: TextStyle(fontSize: 34)),
              ),
            ),
            Expanded(flex: 30, child: Container()),
            Flexible(
              flex: 8,
              child: Center(
                child: TextButton(
                  onPressed: () => customNav(const About(), context),
                  child: const Text('About', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
