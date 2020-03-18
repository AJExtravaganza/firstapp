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
  bool suppressTileMenu = false;

  StashView({this.suppressTileMenu = false});

  @override
  Widget build(BuildContext context) {
    updateTeaData(context);

    Widget stashListWidget(TeaCollectionModel teas) => Expanded(
          child: ListView.builder(
              itemCount: teas.length,
              itemBuilder: (BuildContext context, int index) =>
                  StashListItem(teas.items[index], suppressTileMenu: this.suppressTileMenu)),
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
  final bool suppressTileMenu;
  bool popAfterSelection;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(tea.asString()),
        subtitle:
            Text('${tea.quantity}x ${tea.production.nominalWeightGrams}g' + '\n'
                'Default Profile: ${tea.defaultBrewProfile.name}'),
        trailing: this.suppressTileMenu ? Container(width: 1, height: 1,) : PopupMenuButton<StashTileInteraction>(
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
          Provider.of<ActiveTeaSessionModel>(context, listen: false).tea = tea;
          if (this.popAfterSelection) {
            Navigator.pop(context);
          } else {
            context.findAncestorStateOfType<HomeViewState>().switchToTab(HomeViewState.SESSIONTABIDX);
          }
        },
      ),
    );
  }

  StashListItem(this.tea, {this.suppressTileMenu = false}) {this.popAfterSelection = this.suppressTileMenu;}
}
