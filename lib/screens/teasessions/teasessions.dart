import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/screens/teasessions/steep_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class SessionsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SessionsView();
}

class _SessionsView extends State<SessionsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: BrewProfileInfo(),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      color: Colors.grey, child: Text('EvaluationAreaStub')),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text('SteepTimerStub')//SteepTimer(),
          )
        ]);
  }
}

class BrewProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tea currentTea = Provider.of<ActiveTeaSessionModel>(context).tea;
    if (currentTea == null) {
      return Center(
        child: SelectTeaButton(),
      );
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Expanded(flex: 6, child: TeaNameRow()),
          Expanded(flex: 3, child: BrewingParametersRow()),
          Expanded(
            flex: 3,
            child: Container(),
          ),
        ],
      );
    }
  }
}

class SelectTeaButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {context.findAncestorStateOfType<HomeViewState>().setActiveTab(1);},
      child: Text('Select Tea'),
    );
  }
}

class TeaNameRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tea currentTea = Provider.of<ActiveTeaSessionModel>(context).tea;

    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
                child: Text(
          currentTea.asString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        )))
      ],
    );
  }
}

class BrewingParametersRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BrewingVessel currentBrewingVessel =
        Provider.of<ActiveTeaSessionModel>(context).brewingVessel;
    BrewProfile currentBrewProfile =
        Provider.of<ActiveTeaSessionModel>(context).brewProfile;
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: Container(),
      ),
      Expanded(
        flex: 4,
        child: BrewingParameterRowElement(FontAwesomeIcons.leaf,
            '${currentBrewProfile.getDose(currentBrewingVessel).toStringAsFixed(1)}g'),
      ),
      Expanded(
        flex: 1,
        child: Container(),
      ),
      Expanded(
          flex: 4,
          child: BrewingParameterRowElement(FontAwesomeIcons.balanceScale,
              '1:${currentBrewProfile.nominalRatio}')),
      Expanded(
        flex: 1,
        child: Container(),
      ),
      Expanded(
        flex: 4,
        child: BrewingParameterRowElement(FontAwesomeIcons.tint,
            '${currentBrewingVessel.volumeMilliliters}ml'),
      ),
      Expanded(
        flex: 1,
        child: Container(),
      ),
      Expanded(
        flex: 4,
        child: BrewingParameterRowElement(FontAwesomeIcons.temperatureHigh,
            '${currentBrewProfile.brewTemperatureCelsius}°C'),
      ),
      Expanded(
        flex: 1,
        child: Container(),
      ),
    ]);
  }
}

class BrewingParameterRowElement extends StatelessWidget {
  final IconData icon;
  final String valueText;

  BrewingParameterRowElement(this.icon, this.valueText);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FaIcon(this.icon),
        Text(
          ' ' + this.valueText,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }
}
