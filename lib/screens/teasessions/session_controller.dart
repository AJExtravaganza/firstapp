import 'dart:async';

import 'package:firstapp/models/active_tea_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';


class SessionController extends StatefulWidget {
  final Function(BuildContext) child;

  SessionController({@required this.child});

  @override
  State<SessionController> createState() => SessionControllerState(this.child);
}

class SessionControllerState extends State<SessionController> {
  final Function(BuildContext) childWidget;

  ActiveTeaSessionModel _activeTeaSession;
  bool _deviceHasVibrator = false;
  bool _muted = false;

  bool get active => _timer != null && _timer.isActive;

  bool get muted => _muted;

  set muted(bool state) {
    setState(() {
      _muted = state;
    });
  }

  SessionControllerState(this.childWidget);

  @override
  void initState() {
    Vibration.hasVibrator().then((hasVibration) {
      _deviceHasVibrator = hasVibration;
    });
    super.initState();
  }

  void _resetTimerListener() {
    _resetTimer();
  }

  @override
  void dispose() {
    _activeTeaSession.removeListener(_resetTimerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeTeaSession == null) {
      print("Linking _SteepTimer to ActiveTeaSession");
      _activeTeaSession = Provider.of<ActiveTeaSessionModel>(context);
      _activeTeaSession.addListener(_resetTimerListener);
    }

    if (_timeRemaining == null) {
      _resetTimer();
    }
    return this.childWidget(context);
  }

  decrementSteep() {
    try {
      if (_activeTeaSession.currentSteep > 1) {
        _activeTeaSession.decrementSteep();
      }

      if (_timer != null) {
        _timer.cancel();
      }

      _resetTimer();
    } catch (err) {
      //display a message
      print(err.toString());
    }
  }

  incrementSteep() {
    try {
      _activeTeaSession.incrementSteep();

      if (_timer != null) {
        _timer.cancel();
      }

      _resetTimer();
    } catch (err) {
      //display a message
      print(err.toString());
    }
  }

  _resetTimer() {
    _cancelBrewTimer();
    setState(() {
      _timeRemaining = Duration(
          seconds: _activeTeaSession
              .brewProfile.steepTimings[_activeTeaSession.currentSteep]);
    });
  }

  Timer _timer;
  Duration _timeRemaining;

  Duration get timeRemaining => _timeRemaining;

  set timeRemaining(Duration newTimeRemaining) {
    setState(() {
      _timeRemaining = newTimeRemaining;
    });
  }

  void _cancelBrewTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startBrewTimer() {
    if (_timer == null || !_timer.isActive) {
      const oneSecond = Duration(seconds: 1);
      setState(() {
        _timer = new Timer.periodic(oneSecond, (Timer timer) {
          if (_timeRemaining > Duration(seconds: 0)) {
            setState(() {
              _timeRemaining -= Duration(seconds: 1);
            });
          }

          if (!(_timeRemaining > Duration(seconds: 0))) {
            timer.cancel();
            if (_deviceHasVibrator) {
              Vibration.vibrate(duration: 1000, amplitude: 255);
            }
            if (!_muted || !_deviceHasVibrator) {
              FlutterRingtonePlayer.playNotification();
            }
            incrementSteep();
          }
        });
      });
    }
  }

  void stopBrewTimer() {
    setState(() {
      if (_timer != null) {
        _timer.cancel();
      }
    });
  }
}
