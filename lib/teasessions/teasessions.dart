import 'package:firstapp/models.dart';
import 'package:firstapp/teasessions/brew_profile_info.dart';
import 'package:firstapp/teasessions/steep_counter.dart';
import 'package:firstapp/teasessions/steep_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SessionsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SessionsView();
}

class _SessionsView extends State<SessionsView> {

  int currentSteep = 0;
  Tea selectedTea;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: BrewProfileInfoDisplay(),
          ),
          Expanded(
            flex: 3,
            child: SteepCounter(),
          ),
          Expanded(
            flex: 4,
            child: SteepTimer(),
          )
        ]);
  }
}
