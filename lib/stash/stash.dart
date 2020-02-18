import 'package:firstapp/models.dart';
import 'package:firstapp/models/stash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StashModel>(
      builder: (context, stash, child) {
        List<Tea> stashContents = stash.items;
        return ListView.builder(
            itemCount: stash.length,
            itemBuilder: (BuildContext context, int index) =>
                StashListItem(stashContents[index]));
      },
    );
  }
}

class StashListItem extends StatelessWidget {
  final Tea tea;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(tea.asString()),
        subtitle: Text('Tea info goes here'),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
      ),
    );
  }

  StashListItem(this.tea);
}
