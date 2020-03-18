import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:firstapp/screens/stash/brew_profile_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewProfilesScreen extends StatelessWidget {
  final Tea _tea;

  BrewProfilesScreen(this._tea);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Brew Profile'),
      ),
      body: getBrewProfilesListView(_tea, context),
    );
  }

  Widget getBrewProfilesListView(Tea _tea, BuildContext context) {
    final tea = Provider.of<TeaCollectionModel>(context).getUpdated(_tea);
    if (tea.brewProfiles.length == 0) {
      return getAddBrewProfileWidget(context, tea);
    }

    return Column(children: <Widget>[
      Expanded(
        child: ListView.builder(
            itemCount: tea.brewProfiles.length,
            itemBuilder: (BuildContext context, int index) =>
                BrewProfilesListItem(tea.brewProfiles[index], tea)),
      ),
      getAddBrewProfileWidget(context, tea)
    ]);
  }

  Widget getAddBrewProfileWidget(BuildContext context, Tea tea) {
    return Card(
        child: Row(
      children: <Widget>[
        Expanded(
            child: Center(
                child: RaisedButton(
          child: Text("Add New Brew Profile"),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNewBrewProfile(tea)));
          },
        )))
      ],
    ));
  }
}

enum BrewProfilesTileInteraction { edit, setDefault, delete }

class BrewProfilesListItem extends StatelessWidget {
  final BrewProfile _brewProfile;
  final Tea _tea;

  BrewProfilesListItem(this._brewProfile, this._tea);

  String steepTimeAsHMS(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 60 * 60) {
      int minutes = (seconds / 60).toInt();
      seconds %= 60;
      return seconds > 0 ? '${minutes}m${seconds}s' : '${minutes}m';
    } else {
      int hours = (seconds / 3600).toInt();
      int minutes = (seconds % 3600 / 60).toInt();
      return minutes > 0 ? '${hours}h${minutes}m' : '${hours}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(_brewProfile.name),
        subtitle: Text('1:${_brewProfile.nominalRatio}, ${_brewProfile.brewTemperatureCelsius}°C' +
            '\n'
                '${_brewProfile.steepTimings.map(steepTimeAsHMS).join('/')}'),
        trailing: PopupMenuButton<BrewProfilesTileInteraction>(
          onSelected: (BrewProfilesTileInteraction result) {
            if (result == BrewProfilesTileInteraction.edit) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditBrewProfile(_tea, _brewProfile)));
            } else if (result == BrewProfilesTileInteraction.delete) {
//              delete();
            } else {
              throw Exception(
                  'You managed to select an invalid StashTileInteraction.  Good job, guy.');
            }
          },
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<BrewProfilesTileInteraction>>[
            const PopupMenuItem<BrewProfilesTileInteraction>(
              value: BrewProfilesTileInteraction.edit,
              child: Text('Edit'),
            ),
            const PopupMenuItem<BrewProfilesTileInteraction>(
              value: BrewProfilesTileInteraction.delete,
              child: Text('Delete'),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
        Provider.of<ActiveTeaSessionModel>(context, listen: false).brewProfile = _brewProfile;
        Navigator.pop(context);
        },
      ),
    );
  }
}
