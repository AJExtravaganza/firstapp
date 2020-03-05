import 'package:firstapp/main.dart';
import 'package:firstapp/models/tea.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teas = context.findAncestorStateOfType<MyAppState>().teas;
    return ListView.builder(
        itemCount: teas.length,
        itemBuilder: (BuildContext context, int index) =>
            StashListItem(teas.items[index]));
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
