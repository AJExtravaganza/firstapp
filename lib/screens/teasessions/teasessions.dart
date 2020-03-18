import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/screens/stash/brew_profiles_screen.dart';
import 'package:firstapp/screens/stash/stash.dart';
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
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? _portraitSessionsView(context)
        : _landscapeSessionsView(context);
  }

  Widget _portraitSessionsView(BuildContext context) {
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

  Widget _landscapeSessionsView(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: BrewProfileInfo(),
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
      return Material(
          borderRadius: (BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0))),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              selectTeaFromStash(context);
            },
            child: Center(
                child: Column(children: <Widget>[
              Text(
                '\n\nWelcome to TeaVault!',
                style: TextStyle(fontSize: 24),
              ),
              Text('  Add some tea to your stash to get started...')
            ])),
          ));
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Expanded(flex: 6, child: TeaNameRow()),
          Expanded(
              flex: 6,
              child: Column(
                children: [BrewingParametersRow(), BrewProfileNameRow()],
              )),
//          Expanded(flex: 3, child: BrewingParametersRow()),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      );
    }
  }
}

void selectTeaFromStash(BuildContext context) {
//  //TODO: Implement select pot
//  Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => Scaffold(
//            appBar: AppBar(title: Text("Select a Tea")),
//            body: StashView(true),
//          )));

  final selectTeaRoute = MaterialPageRoute(
      builder: (context) => Scaffold(
            appBar: AppBar(title: Text("Select a Tea")),
            body: StashView(suppressTileMenu: true),
          ));

  Navigator.push(context, selectTeaRoute);

  selectTeaRoute.popped.then((_) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BrewProfilesScreen(
                  Provider.of<ActiveTeaSessionModel>(context).tea,
                  suppressTileMenu: true,
                )));
  });
}

class TeaNameRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tea currentTea = Provider.of<ActiveTeaSessionModel>(context).tea;
    return InkWell(
      onTap: () {
        selectTeaFromStash(context);
      },
      child: Row(
        children: <Widget>[
          Expanded(
              child: Center(
                  child: Text(
            currentTea.asString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          )))
        ],
      ),
    );
  }
}

class BrewProfileNameRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveTeaSessionModel>(
        builder: (context, activeTeaSession, child) => Row(children: <Widget>[
              Expanded(
                  child: Center(
                child:
                    Text('Brew Profile: ${activeTeaSession.brewProfile.name}'),
              ))
            ]));
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
        flex: 10,
        child: Container(),
      ),
      Expanded(
        flex: 40,
        child: BrewingParameterRowElement(FontAwesomeIcons.leaf,
            '${currentBrewProfile.getDose(currentBrewingVessel).toStringAsFixed(1)}g'),
      ),
      Expanded(
        flex: 10,
        child: Container(),
      ),
      Expanded(
          flex: 42,
          child: BrewingParameterRowElement(FontAwesomeIcons.balanceScale,
              '1:${currentBrewProfile.nominalRatio}')),
      Expanded(
        flex: 8,
        child: Container(),
      ),
      Expanded(
        flex: 40,
        child: BrewingParameterRowElement(FontAwesomeIcons.tint,
            '${currentBrewingVessel.volumeMilliliters}ml'),
      ),
      Expanded(
        flex: 10,
        child: Container(),
      ),
      Expanded(
        flex: 40,
        child: BrewingParameterRowElement(FontAwesomeIcons.temperatureHigh,
            '${currentBrewProfile.brewTemperatureCelsius}°C'),
      ),
      Expanded(
        flex: 10,
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
