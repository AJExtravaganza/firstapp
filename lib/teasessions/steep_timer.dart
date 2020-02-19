import 'dart:async';
import 'dart:math';

import 'package:firstapp/models/active_tea_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';

class SteepTimer extends StatefulWidget {
  @override
  State<SteepTimer> createState() => _SteepTimer();
}

class _SteepTimer extends State<SteepTimer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeRemaining == null) {
      _resetTimer();
    }
    return Column(
      children: <Widget>[SteepCountRow(), TimerDisplay(), SteepTimerControls()],
    );
  }


  decrementSteep() {
    try {
      Provider.of<ActiveTeaSessionModel>(context, listen: false).decrementSteep();

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
      Provider.of<ActiveTeaSessionModel>(context, listen: false).incrementSteep();

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
    ActiveTeaSessionModel activeTeaSession =
        Provider.of<ActiveTeaSessionModel>(context, listen: false);

    setState(() {
      _timeRemaining = Duration(
          seconds: activeTeaSession
              .brewProfile.steepTimings[activeTeaSession.currentSteep]);
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

      if (!(_timeRemaining > Duration(seconds: 0))) {
        timer.cancel();
        FlutterRingtonePlayer.playNotification();
        incrementSteep();
      }
    });
  }
}

class SteepCountRow extends StatelessWidget {
  String getCurrentSteepText(BuildContext context) {
    ActiveTeaSessionModel activeTeaSession =
        Provider.of<ActiveTeaSessionModel>(context);

    if (activeTeaSession.currentSteep == 0) {
      return 'Rinse';
    } else {
      return 'Steep ${activeTeaSession.currentSteep}';
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
