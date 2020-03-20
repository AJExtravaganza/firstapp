import 'dart:async';

import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/brew_profile.dart';
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

  ActiveTeaSessionModel activeTeaSession;
  bool _deviceHasVibrator = false;
  bool _muted = false;

  Timer _timer;
  Duration _timeRemaining;
  bool _finished = false;

  Duration get timeRemaining => _timeRemaining;

  bool get active => _timer != null && _timer.isActive;
  bool get finished => _finished;

  bool get muted => _muted;

  int get currentSteep => activeTeaSession.currentSteep;
  int get steepsRemainingInProfile => activeTeaSession.brewProfile.steepTimings.length - currentSteep;

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
    activeTeaSession.removeListener(_resetTimerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (activeTeaSession == null) {
      print("Linking _SteepTimer to ActiveTeaSession");
      activeTeaSession = Provider.of<ActiveTeaSessionModel>(context);
      activeTeaSession.addListener(_resetTimerListener);
    }

    if (_timeRemaining == null) {
      _resetTimer();
    }
    return this.childWidget(context);
  }

  decrementSteep() {
//    try {
      if (activeTeaSession.currentSteep > 0) {
        activeTeaSession.decrementSteep();
      }

      if (_timer != null) {
        _timer.cancel();
      }

      _resetTimer();
//    } catch (err) {
//      //display a message
//      print(err.toString());
//    }
  }

  incrementSteep() {
//    try {
      activeTeaSession.incrementSteep();

      if (_timer != null) {
        _timer.cancel();
      }

      _resetTimer();
//    } catch (err) {
//      //display a message
//      print(err.toString());
//    }
  }

  _resetTimer() {
    _cancelBrewTimer();
    setState(() {
      _finished = false;
      _timeRemaining = Duration(
          seconds: activeTeaSession
              .brewProfile.steepTimings[activeTeaSession.currentSteep]);
    });
  }

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
            setState(() {
              _finished = true;
            });
            timer.cancel();
            if (_deviceHasVibrator) {
              Vibration.vibrate(duration: 1000, amplitude: 255);
            }
            if (!_muted || !_deviceHasVibrator) {
              FlutterRingtonePlayer.playNotification();
            }
//            incrementSteep();
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

  saveSteepTimeToBrewProfile() async {
    await activeTeaSession.saveSteepTimeToBrewProfile(currentSteep, timeRemaining);
  }
}
