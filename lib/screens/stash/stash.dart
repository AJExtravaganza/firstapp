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
  @override
  Widget build(BuildContext context) {
    updateTeaData(context);
    return Consumer<TeaCollectionModel>(
        builder: (context, teas, child) =>
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: teas.length,
                      itemBuilder: (BuildContext context, int index) =>
                          StashListItem(teas.items[index])),
                ),
                getAddTeaListItem(context)
              ],
            ));
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
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddNewTeaToStash()));
                    },
                  )))
        ],
      ));
}

enum StashTileInteraction { makeActiveSessionTea, brewProfiles }

class StashListItem extends StatelessWidget {
  final Tea tea;

  @override
  Widget build(BuildContext context) {
    final selectTeaAndGoToSessionTab = () {
      Provider.of<ActiveTeaSessionModel>(context, listen: false)
          .resetSession(tea);
      context
          .findAncestorStateOfType<HomeViewState>()
          .setActiveTab(HomeViewState.SESSIONTABIDX);
    };

    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(tea.asString()),
        subtitle:
        Text('${tea.quantity}x ${tea.production.nominalWeightGrams}g'),
        trailing: PopupMenuButton<StashTileInteraction>(
          onSelected: (StashTileInteraction result) {
            if (result == StashTileInteraction.makeActiveSessionTea) {
              selectTeaAndGoToSessionTab();
            } else if (result == StashTileInteraction.brewProfiles){
              Navigator.push(context, MaterialPageRoute(builder: (context) => BrewProfilesScreen(tea)));
            }else {
            throw Exception(
            'You managed to select an invalid StashTileInteraction.  Good job, guy.');
            }
            },
          itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<StashTileInteraction>>[
            const PopupMenuItem<StashTileInteraction>(
              value: StashTileInteraction.makeActiveSessionTea,
              child: Text('Select Tea'),
            ),
            const PopupMenuItem<StashTileInteraction>(
              value: StashTileInteraction.brewProfiles,
              child: Text('Brew Profiles'),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          if (context
              .findAncestorStateOfType<HomeViewState>()
              .stashTeaSelectionMode) {
            selectTeaAndGoToSessionTab();
          }
        },
      ),
    );
  }

  StashListItem(this.tea);
}
