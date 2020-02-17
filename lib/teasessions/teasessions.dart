import 'package:firstapp/models.dart';
import 'package:firstapp/teasessions/steep_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SessionsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SessionsView();
}

class _SessionsView extends State<SessionsView> {
  Tea selectedTea = getSampleTeaList()[0];
  BrewingVessel selectedBrewingVessel = getSampleVesselList()[0];
  List<BrewProfile> brewProfiles = getSampleBrewProfileList();

  BrewProfile getCurrentBrewProfile() {
    for (final brewProfile in brewProfiles) {
      if (brewProfile.tea == selectedTea) {
        return brewProfile;
      }
    }

    throw Exception('No BrewProfile exists for tea ${selectedTea.asString()}');
  }

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
            flex: 3,
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
            flex: 4,
            child: SteepTimer(),
          )
        ]);
  }
}

class BrewProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tea currentTea =
        context.findAncestorStateOfType<_SessionsView>().selectedTea;
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
    Tea currentTea =
        context.findAncestorStateOfType<_SessionsView>().selectedTea;

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
    _SessionsView sessionState =
        context.findAncestorStateOfType<_SessionsView>();
    BrewingVessel brewingVessel = sessionState.selectedBrewingVessel;
    BrewProfile brewProfile = context
        .findAncestorStateOfType<_SessionsView>()
        .getCurrentBrewProfile();
    return Row(children: <Widget>[
      Expanded(
        flex: 2,
        child: Container(),
      ),
      Expanded(
        flex: 2,
        child: BrewingParameterRowElement(Icons.blur_circular,
            '${brewProfile.getDose(brewingVessel).toStringAsFixed(1)}g'),
      ),
      Expanded(
          flex: 2,
          child: BrewingParameterRowElement(
              Icons.blur_off, '1:${brewProfile.nominalRatio}')),
      Expanded(
        flex: 2,
        child: BrewingParameterRowElement(
            Icons.network_wifi, '${brewingVessel.volumeMilliliters}ml'),
      ),
      Expanded(
        flex: 2,
        child: BrewingParameterRowElement(
            Icons.ac_unit, '${brewProfile.brewTemperature}°C'),
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
