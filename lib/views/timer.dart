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

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:farer_companion/common/vars/globals.dart';
import 'package:farer_companion/common/vars/prefs.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final List<Phase> _phases = [
    Phase(
      name: 'Noontide - Free Farm',
      night: false,
      duration: const Duration(seconds: 270),
    ),
    Phase(
      name: 'Night - Circle Closing',
      night: true,
      duration: const Duration(seconds: 180),
    ),
    Phase(
      name: 'Noontide - Free Farm',
      night: false,
      duration: const Duration(seconds: 210),
    ),
    Phase(
      name: 'Night - Circle Closing',
      night: true,
      duration: const Duration(seconds: 180),
    ),
  ];
  final Duration _one = const Duration(seconds: 1);
  late Duration _total;
  late Duration _remaining;
  late Duration _duration;
  late Duration _elapsed;
  late int _index;
  late bool _notEnded;
  late Timer _timer;
  bool _dayOne = true;
  final double _vibrateBefore = prefs.getDouble(PrefsKeys.vibrateBefore.name)!;

  void _startTimer() {
    _total = const Duration(seconds: 840);
    _elapsed = Duration.zero;
    _index = 0;
    _notEnded = true;
    _duration = _phases[_index].duration;
    _remaining = _duration;
    _timer = Timer.periodic(_one, (timer) {
      if (hasVibrator && _remaining.inSeconds == _vibrateBefore && _vibrateBefore != 0) {
        Vibration.vibrate(pattern: [0, 750, 250, 750], intensities: [1, 255, 128, 255]);
      }
      setState(() {
        if (_elapsed != _duration) {
          _elapsed += _one;
          _remaining -= _one;
          _total -= _one;
        } else {
          _index++;
          if (_index < 4) {
            _duration = _phases[_index].duration;
            _remaining = _duration;
            _elapsed = Duration.zero;
          } else {
            _endDay();
          }
        }
      });
    });
  }

  void _endDay() {
    setState(() {
      _timer.cancel();
      _notEnded = false;
    });
  }

  @override
  void initState() {
    WakelockPlus.enable();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text(
            'Are you sure you want to go back?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Timer'),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 3,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _timer.cancel();
                          _startTimer();
                          _dayOne = true;
                        });
                      },
                      child: Text(
                        'Restart timer',
                        style: TextStyle(fontSize: screenHeight * 0.024),
                      ),
                    ),
                    SizedBox(width: screenHeight * 0.03),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _timer.cancel();
                          _startTimer();
                        });
                      },
                      child: Text(
                        'Restart day',
                        style: TextStyle(fontSize: screenHeight * 0.024),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Center(
                child: Text(
                  '  Double press the circle\nto skip the current phase',
                  style: TextStyle(fontSize: screenHeight * 0.016),
                ),
              ),
            ),
            Flexible(
              flex: 36,
              child: Center(
                child: _notEnded
                    ? GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            _index++;
                            if (_index < 4) {
                              _elapsed = Duration.zero;
                              _total -= _remaining;
                              _duration = _phases[_index].duration;
                              _remaining = _duration;
                            } else {
                              _endDay();
                            }
                          });
                        },
                        child: CircularPercentIndicator(
                          lineWidth: screenHeight * 0.023,
                          backgroundWidth: screenHeight * 0.015,
                          radius: screenHeight * 0.19,
                          backgroundColor: _phases[_index].night
                              ? const Color.fromARGB(255, 59, 9, 174)
                              : const Color.fromARGB(255, 216, 210, 16),
                          progressColor: Colors.red,
                          percent:
                              _elapsed.inSeconds / _phases[_index].duration.inSeconds,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _phases[_index].name,
                                style: TextStyle(fontSize: screenHeight * 0.02),
                              ),
                              Text(
                                '${_remaining.inMinutes}:${(_remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              Text(
                                'Total: ${_total.inMinutes}:${(_total.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: screenHeight * 0.02),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: screenHeight * 0.38,
                        width: screenHeight * 0.38,
                        child: Column(
                          children: [
                            Flexible(
                              child: Center(
                                child: Text(
                                  'The day has ended',
                                  style: TextStyle(fontSize: screenHeight * 0.028),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Break a leg!',
                                style: TextStyle(fontSize: screenHeight * 0.028),
                              ),
                            ),
                            _dayOne
                                ? Flexible(
                                    child: Center(
                                      child: FilledButton(
                                        onPressed: () {
                                          setState(() {
                                            _startTimer();
                                            _dayOne = false;
                                          });
                                        },
                                        child: Text(
                                          'Next Day',
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.044,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
              ),
            ),
            Expanded(flex: 6, child: Container()),
          ],
        ),
      ),
    );
  }
}

class Phase {
  String name;
  Duration duration;
  bool night;

  Phase({required this.name, required this.duration, required this.night});
}
