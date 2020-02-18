import 'package:firstapp/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Tea> stashContents = getSampleTeaList();
    return ListView.builder(
        itemCount: stashContents.length,
        itemBuilder: (BuildContext context, int index) => StashListItem(stashContents[index]));
  }
}

class StashListItem extends StatelessWidget {
  Tea tea;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(tea.asString()),
        subtitle: Text(
            'Tea info goes here'
        ),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
      ),
    );
  }

  StashListItem(this.tea);
}