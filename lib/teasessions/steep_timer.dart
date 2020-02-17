import 'dart:math';

import 'package:flutter/material.dart';

class SteepTimer extends StatefulWidget {
  @override
  State<SteepTimer> createState() => _SteepTimer();
}

class _SteepTimer extends State<SteepTimer> {
  Duration timerDuration;
  int _currentSteep = 0;

  @override
  void initState() {
    super.initState();
    timerDuration = Duration(seconds: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[TimerDisplay(), SteepTimerControls()],
    );
  }

  int getCurrentSteep() => _currentSteep;

  decrementSteep() {
    int newCurrentSteep = max(1, _currentSteep - 1);
    setState(() {
      _currentSteep = newCurrentSteep;
    });
  }

  incrementSteep() {
    int newCurrentSteep = max(1, _currentSteep - 1);
    setState(() {
      _currentSteep = newCurrentSteep;
    });
  }

  startBrewTimer() {
    // todo: Implement
  }
}

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimer parentTimerState =
        context.findAncestorStateOfType<_SteepTimer>();
    String currentValueStr =
        parentTimerState.timerDuration.toString().split('.').first.substring(2);
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
