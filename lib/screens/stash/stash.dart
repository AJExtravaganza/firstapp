import 'package:firstapp/main.dart';
import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:firstapp/screens/stash/add_new_tea_to_stash_form.dart';
import 'package:firstapp/screens/stash/brew_profiles_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StashView extends StatelessWidget {
  bool _activeTeaSelectionMode = false;

  StashView([this._activeTeaSelectionMode = false]);

  @override
  Widget build(BuildContext context) {
    updateTeaData(context);

    Widget stashListWidget(TeaCollectionModel teas) => Expanded(
          child: ListView.builder(
              itemCount: teas.length,
              itemBuilder: (BuildContext context, int index) =>
                  StashListItem(teas.items[index], _activeTeaSelectionMode)),
        );

    return Consumer<TeaCollectionModel>(
        builder: (context, teas, child) => Column(
            children: [
              stashListWidget(teas),
              getAddTeaListItem(context)]));
  }
}

StatelessWidget getAddTeaListItem(BuildContext context) {
  return Card(
      child: Row(
    children: <Widget>[
      Expanded(
          child: Center(
              child: RaisedButton(
        child: Text("Add New Tea"),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewTeaToStash()));
        },
      )))
    ],
  ));
}

enum StashTileInteraction { brewProfiles }

class StashListItem extends StatelessWidget {
  final Tea tea;
  bool _activeTeaSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(tea.asString()),
        subtitle:
            Text('${tea.quantity}x ${tea.production.nominalWeightGrams}g'),
        trailing: PopupMenuButton<StashTileInteraction>(
          onSelected: (StashTileInteraction result) {
            if (result == StashTileInteraction.brewProfiles) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BrewProfilesScreen(tea)));
            } else {
              throw Exception(
                  'You managed to select an invalid StashTileInteraction.  Good job, guy.');
            }
          },
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<StashTileInteraction>>[
            const PopupMenuItem<StashTileInteraction>(
              value: StashTileInteraction.brewProfiles,
              child: Text('Brew Profiles'),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          if (_activeTeaSelectionMode) {
            Provider.of<ActiveTeaSessionModel>(context, listen: false)
                .resetSession(tea);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  StashListItem(this.tea, [this._activeTeaSelectionMode = false]);
}
