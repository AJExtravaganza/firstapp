import 'dart:async';
import 'dart:math';

import 'package:firstapp/models/active_tea_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    Vibration.hasVibrator().then((hasVibration) {_deviceHasVibrator = hasVibration;});
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
        SteepCountRow(),
        TimerDisplayRow(),
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
    _stopBrewTimer();
    setState(() {
      _timeRemaining = Duration(
          seconds: _activeTeaSession
              .brewProfile.steepTimings[_activeTeaSession.currentSteep]);
    });
  }

  Timer _timer;
  Duration _timeRemaining;

  set timeRemaining(Duration newTimeRemaining) {
    setState(() {
      _timeRemaining = newTimeRemaining;
    });
  }

  void _stopBrewTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
  }

  void startBrewTimer() {
    if (_timer == null || !_timer.isActive) {
      const oneSecond = Duration(seconds: 1);
      _timer = new Timer.periodic(oneSecond, (Timer timer) {
        if (_timeRemaining > Duration(seconds: 0)) {
          setState(() {
            _timeRemaining -= Duration(seconds: 1);
          });
        }

        if (!(_timeRemaining > Duration(seconds: 0))) {
          timer.cancel();
          if (_deviceHasVibrator) {
            Vibration.vibrate(duration: 1000, amplitude: 128);
          }
          FlutterRingtonePlayer.playNotification();
          incrementSteep();
        }
      });
    }
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
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: TimerIconButton(),
                ),
                Expanded(flex: 6, child: TimerDisplay()),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
              ],
            ));
  }
}

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimerState parentTimerState =
        context.findAncestorStateOfType<_SteepTimerState>();
    final currentMinutes =
        (parentTimerState._timeRemaining.inMinutes % 60).toInt();
    final currentSeconds =
        (parentTimerState._timeRemaining.inSeconds % 60).toInt();
    String currentValueStr = parentTimerState._timeRemaining
        .toString()
        .split('.')
        .first
        .substring(2);

    return FlatButton(
      child: Text(
        currentValueStr,
        style: TextStyle(fontSize: 72, fontFamily: 'RobotoMono'),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.ms,
                initialTimerDuration: parentTimerState._timeRemaining,
                onTimerDurationChanged: (Duration newDuration) {
                  parentTimerState.timeRemaining = newDuration;
                })));
      },
    );
  }
}

class TimerIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      alignment: Alignment.centerLeft,
      icon: Icon(Icons.timelapse),
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
    _SteepTimerState sessionState =
        context.findAncestorStateOfType<_SteepTimerState>();
    return RaisedButton(
      onPressed: sessionState.decrementSteep,
      child: Text('Previous\nSteep'),
    );
  }
}

class BrewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimerState sessionState =
        context.findAncestorStateOfType<_SteepTimerState>();
    return RaisedButton(
      onPressed: sessionState.startBrewTimer,
      child: Text('BREW'),
    );
  }
}

class NextSteepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimerState sessionState =
        context.findAncestorStateOfType<_SteepTimerState>();
    return RaisedButton(
      onPressed: sessionState.incrementSteep,
      child: Text('Next\nSteep'),
    );
  }
}
