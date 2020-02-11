import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SessionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Timer(),
        ]);
  }
}

class Timer extends StatefulWidget {
  @override
  State<Timer> createState() => _Timer();
}

class _Timer extends State<Timer> {

  Duration _timerDuration;

  @override
  void initState() {
    super.initState();
    _timerDuration = Duration(seconds: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TimerIconButton(),
//        TimerDisplay()
      ],
    );
  }
}

//class TimerDisplay extends AnimatedWidget{
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return null;
//  }
//
//}

class TimerIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: ()=>{},
        alignment: Alignment.centerLeft,
        icon: Icon(Icons.timelapse),
    );
  }
}
