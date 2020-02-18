import 'dart:async';
import 'dart:math';

import 'package:firstapp/models/brew_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class SteepTimer extends StatefulWidget {
  @override
  State<SteepTimer> createState() => _SteepTimer();
}

class _SteepTimer extends State<SteepTimer> {
  int _currentSteep;
  List<int> _brewProfileSteepTimings;

  @override
  void initState() {
    super.initState();
    _currentSteep = 0;
    _brewProfileSteepTimings = getSampleBrewProfileList()[0].steepTimings;
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[SteepCountRow(), TimerDisplay(), SteepTimerControls()],
    );
  }

  int getCurrentSteep() => _currentSteep;

  decrementSteep() {
    if (! (_currentSteep == 0)) {
      int newCurrentSteep = max(1, _currentSteep - 1);
      setState(() {
        if (_timer != null) {
          _timer.cancel();
        }
        _currentSteep = newCurrentSteep;
      });
      _resetTimer();
    }
  }

  incrementSteep() {
    int newCurrentSteep = min(_brewProfileSteepTimings.length - 1, _currentSteep + 1);
    setState(() {
      if (_timer != null) {
        _timer.cancel();
      }
      _currentSteep = newCurrentSteep;
    });
    _resetTimer();
  }

  _resetTimer() {
    setState(() {
      _timeRemaining = Duration(seconds: _brewProfileSteepTimings[_currentSteep]);
    });
  }

  Timer _timer;
  Duration _timeRemaining;

  void startBrewTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSecond, (Timer timer) {
      if (_timeRemaining > Duration(seconds: 0)) {
        setState(() {
          _timeRemaining -= Duration(seconds: 1);
        });
      }

      if (!(_timeRemaining > Duration(seconds: 0))){
        timer.cancel();
        FlutterRingtonePlayer.playNotification();
        incrementSteep();
      }
    });
  }
}

class SteepCountRow extends StatelessWidget {
  String getCurrentSteepText(BuildContext context) {
    _SteepTimer parentTimerState =
        context.findAncestorStateOfType<_SteepTimer>();

    if (parentTimerState.getCurrentSteep() == 0) {
      return 'Rinse';
    } else {
      return 'Steep ${parentTimerState.getCurrentSteep()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Text(
            getCurrentSteepText(context),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimer parentTimerState =
        context.findAncestorStateOfType<_SteepTimer>();
    String currentValueStr = parentTimerState._timeRemaining
        .toString()
        .split('.')
        .first
        .substring(2);
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 1,
          child: TimerIconButton(),
        ),
        Expanded(
            flex: 6,
            child: FlatButton(
              child: Text(
                currentValueStr,
                style: TextStyle(fontSize: 72, fontFamily: 'RobotoMono'),
              ),
              onPressed: () {},
            )),
        Expanded(
          flex: 2,
          child: Container(),
        ),
      ],
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
    _SteepTimer sessionState = context.findAncestorStateOfType<_SteepTimer>();
    return RaisedButton(
      onPressed: sessionState.decrementSteep,
      child: Text('Previous\nSteep'),
    );
  }
}

class BrewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimer sessionState = context.findAncestorStateOfType<_SteepTimer>();
    return RaisedButton(
      onPressed: sessionState.startBrewTimer,
      child: Text('BREW'),
    );
  }
}

class NextSteepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimer sessionState = context.findAncestorStateOfType<_SteepTimer>();
    return RaisedButton(
      onPressed: sessionState.incrementSteep,
      child: Text('Next\nSteep'),
    );
  }
}
