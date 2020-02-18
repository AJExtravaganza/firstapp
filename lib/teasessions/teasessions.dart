import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/teasessions/steep_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
            child: SteepTimer(),
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
          Expanded(flex: 3, child: TeaNameRow()),
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
      onPressed: () {},
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
          style: TextStyle(fontSize: 20),
        )))
      ],
    );
  }
}

class BrewingParametersRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BrewingVessel currentBrewingVessel = Provider.of<ActiveTeaSessionModel>(context).brewingVessel;
    BrewProfile currentBrewProfile = Provider.of<ActiveTeaSessionModel>(context).brewProfile;
    return Row(children: <Widget>[
      Expanded(
        flex: 2,
        child: Container(),
      ),
      Expanded(
        flex: 2,
        child: BrewingParameterRowElement(Icons.blur_circular,
            '${currentBrewProfile.getDose(currentBrewingVessel).toStringAsFixed(1)}g'),
      ),
      Expanded(
          flex: 2,
          child: BrewingParameterRowElement(
              Icons.blur_off, '1:${currentBrewProfile.nominalRatio}')),
      Expanded(
        flex: 2,
        child: BrewingParameterRowElement(
            Icons.network_wifi, '${currentBrewingVessel.volumeMilliliters}ml'),
      ),
      Expanded(
        flex: 2,
        child: BrewingParameterRowElement(
            Icons.ac_unit, '${currentBrewProfile.brewTemperature}°C'),
      ),
      Expanded(
        flex: 2,
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
      children: <Widget>[Icon(this.icon), Text(this.valueText)],
    );
  }
}
