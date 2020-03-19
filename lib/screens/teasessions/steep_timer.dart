import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/screens/teasessions/session_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SteepTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TimerDisplayRow(),
        SteepCountRow(),
        SteepTimerControls()
      ],
    );
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
    final _context = context;
    final timerState =
        context.findAncestorStateOfType<SessionControllerState>();
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
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            builder: (context) => TimerPickerSheetContents(_context, timerState));
      },
    );
  }
}

class TimerPickerSheetContents extends StatelessWidget {
  final SessionControllerState _timerState;
  final BuildContext _parentContext;

  TimerPickerSheetContents(this._parentContext, this._timerState);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final portrait = Orientation.portrait;
    int buttonFlex = orientation == portrait ? 15 : 20;
    int timerPickerFlex = orientation == portrait ? 50 : 40;

    return Container(
        height: 200,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                )),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: buttonFlex,
                  child: _timerState.activeTeaSession.currentTea != null
                      ? IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            Scaffold.of(_parentContext).showSnackBar(SnackBar(content: Text("Saving change to brew profile...")));
                            await _timerState.saveSteepTimeToBrewProfile();
                          },
                          icon: Icon(Icons.save_alt),
                          iconSize: 48,
                        )
                      : Container(),
                ),
                Expanded(
                  flex: timerPickerFlex,
                  child: BrewTimerPicker(this._timerState),
                ),
                Expanded(
                  flex: buttonFlex,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.check_box),
                    iconSize: 48,
                  ),
                ),
              ],
            )));
  }
}

class BrewTimerPicker extends StatelessWidget {
  final SessionControllerState timerState;

  BrewTimerPicker(this.timerState);

  @override
  Widget build(BuildContext context) {
    return CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.ms,
        initialTimerDuration: timerState.timeRemaining,
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
    final timerState =
        context.findAncestorStateOfType<SessionControllerState>();

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
    final timerState =
        context.findAncestorStateOfType<SessionControllerState>();
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
    final timerState =
        context.findAncestorStateOfType<SessionControllerState>();

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
    final timerState =
        context.findAncestorStateOfType<SessionControllerState>();
    return IconButton(
        onPressed: () {
          if (timerState.steepsRemainingInProfile > 1)
            timerState.incrementSteep();
        },
        icon: Icon(Icons.arrow_forward_ios));
  }
}
