import 'dart:collection';

import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_production_collection.dart';
import 'package:flutter/cupertino.dart';

class TeaCollectionModel extends ChangeNotifier {
  TeaProductionCollectionModel productions;
  final Map<String, Tea> _items = {};

  UnmodifiableListView<Tea> get items => UnmodifiableListView(_items.values);

  int get length => _items.length;

  void update() async {
    print('Updating tea collection');
    final user = await fetchUser();
    final userStashQuery =
        await user.reference.collection('teas_in_stash').getDocuments();
    final userStashContents = userStashQuery.documentChanges.map(
        (documentChange) => Tea(documentChange.document, this.productions));
    userStashContents.forEach((tea) {print(tea.asString());});
    this._items.addAll(Map.fromIterable(userStashContents,
        key: (tea) => tea.id, value: (tea) => tea));

    notifyListeners();
  }

  TeaCollectionModel(TeaProductionCollectionModel productions) {
    this.productions = productions;
  }
}
