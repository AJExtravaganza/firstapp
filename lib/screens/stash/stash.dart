import 'package:firstapp/main.dart';
import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeaCollectionModel>(
        builder: (context, teas, child) => ListView.builder(
          itemCount: teas.length,
          itemBuilder: (BuildContext context, int index) =>
              StashListItem(teas.items[index])));
  }
}

enum StashTileInteraction { makeActiveSessionTea }

class StashListItem extends StatelessWidget {
  final Tea tea;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(tea.asString()),
        subtitle: Text('${tea.quantity}x ${tea.production.nominalWeightGrams}g'),
        trailing: PopupMenuButton<StashTileInteraction>(
          onSelected: (StashTileInteraction result) {
            if (result == StashTileInteraction.makeActiveSessionTea) {
              context.findAncestorStateOfType<HomeViewState>().setActiveTab(0);
              Provider.of<ActiveTeaSessionModel>(context, listen: false).tea = tea;
            } else {
              throw Exception('You managed to select an invalid StashTileInteraction.  Good job, guy.');
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<StashTileInteraction>>[
            const PopupMenuItem<StashTileInteraction>(
              value: StashTileInteraction.makeActiveSessionTea,
              child: Text('Select Tea'),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  StashListItem(this.tea);
}
