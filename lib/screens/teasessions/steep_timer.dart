import 'dart:async';
import 'dart:math';

import 'package:firstapp/models/active_tea_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class SteepTimer extends StatefulWidget {
  @override
  State<SteepTimer> createState() => _SteepTimerState();
}

class _SteepTimerState extends State<SteepTimer> {
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
    return Column(
      children: <Widget>[
        TimerDisplayRow(),
        SteepCountRow(),
        SteepTimerControls()
      ],
    );
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
      _timer.cancel();
    });
  }
}

class SteepCountRow extends StatelessWidget {
  String getSteepText(int steep) {
    return steep == 0 ? 'Rinse' : 'Steep ${steep}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveTeaSessionModel>(
        builder: (context, activeTeaSession, child) => Row(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Text(
                    getSteepText(activeTeaSession.currentSteep),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ));
  }
}

class TimerDisplayRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveTeaSessionModel>(
        builder: (context, activeTeaSession, child) => Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: TimerIconButton(),
                ),
                Expanded(flex: 12, child: TimerDisplay()),
                Expanded(
                  flex: 2,
                  child: TimerMuteIconButton(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ));
  }
}

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.findAncestorStateOfType<_SteepTimerState>();
    final currentMinutes = (timerState.timeRemaining.inMinutes % 60).toInt();
    final currentSeconds = (timerState.timeRemaining.inSeconds % 60).toInt();
    String currentValueStr =
        timerState.timeRemaining.toString().split('.').first.substring(2);

    return FlatButton(
      child: Text(
        currentValueStr,
        style: TextStyle(fontSize: 72, fontFamily: 'RobotoMono'),
      ),
      onPressed: () {
        timerState.stopBrewTimer();

        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.white,
            builder: (context) => TimerPickerSheetContents(timerState));
      },
    );
  }
}

class TimerPickerSheetContents extends StatelessWidget {
  final _SteepTimerState _timerState;

  TimerPickerSheetContents(this._timerState);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                )),
            child: BrewTimerPicker(this._timerState)));
  }
}

class BrewTimerPicker extends StatelessWidget {
  final _SteepTimerState timerState;

  BrewTimerPicker(this.timerState);

  @override
  Widget build(BuildContext context) {
    return CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.ms,
        initialTimerDuration: timerState._timeRemaining,
        onTimerDurationChanged: (Duration newDuration) {
          timerState.timeRemaining = newDuration;
        });
  }
}

class TimerIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      alignment: Alignment.center,
      icon: Icon(Icons.timelapse),
    );
  }
}

class TimerMuteIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.findAncestorStateOfType<_SteepTimerState>();

    return IconButton(
      onPressed: () {
        timerState.muted = !timerState.muted;
      },
      alignment: Alignment.center,
      icon: Icon(timerState.muted
          ? Icons.notifications_off
          : Icons.notifications_active),
    );
  }
}

class SteepTimerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 3,
          child: PreviousSteepButton(),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 3,
          child: BrewButton(),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 3,
          child: NextSteepButton(),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}

class PreviousSteepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.findAncestorStateOfType<_SteepTimerState>();
    return IconButton(
      onPressed: timerState.decrementSteep,
      icon: Icon(Icons.arrow_back_ios),
      alignment: Alignment.center,
    );
  }
}

class BrewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.findAncestorStateOfType<_SteepTimerState>();

    if (timerState.active) {
      return IconButton(
        onPressed: timerState.stopBrewTimer,
        icon: Icon(Icons.pause),
        alignment: Alignment.center,
      );
    } else {
      return IconButton(
        onPressed: timerState.startBrewTimer,
        icon: Icon(Icons.play_arrow),
        alignment: Alignment.center,
      );
    }
  }
}

class NextSteepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.findAncestorStateOfType<_SteepTimerState>();
    return IconButton(
        onPressed: timerState.incrementSteep,
        icon: Icon(Icons.arrow_forward_ios));
  }
}
