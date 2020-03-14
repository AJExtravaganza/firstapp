import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/screens/stash/add_new_brew_profile_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrewProfilesScreen extends StatelessWidget {
  final Tea _tea;

  BrewProfilesScreen(this._tea);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brew Profiles'),
      ),
      body: getBrewProfilesListView(_tea, context),
    );
  }

  Widget getBrewProfilesListView(Tea tea, BuildContext context) {
    final brewProfiles = tea.brewProfiles;
    if (tea.brewProfiles.length == 0) {
      return getAddBrewProfileWidget(context, tea);
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: tea.brewProfiles.length,
              itemBuilder: (BuildContext context, int index) =>
                  BrewProfilesListItem(tea.brewProfiles[index])),
        ),
        getAddBrewProfileWidget(context, tea)
      ],
    );
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
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AddNewBrewProfile(tea)));
          },
        )))
      ],
    ));
  }
}

enum BrewProfilesTileInteraction { edit, delete }

class BrewProfilesListItem extends StatelessWidget {
  final BrewProfile _brewProfile;

  BrewProfilesListItem(this._brewProfile);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(_brewProfile.name),
        subtitle: Text('details go here later'),
        trailing: PopupMenuButton<BrewProfilesTileInteraction>(
          onSelected: (BrewProfilesTileInteraction result) {
            if (result == BrewProfilesTileInteraction.edit) {
//              edit();
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
//          if (context
//              .findAncestorStateOfType<HomeViewState>()
//              .stashTeaSelectionMode) {
//            selectTeaAndGoToSessionTab();
//          }
        },
      ),
    );
  }
}
