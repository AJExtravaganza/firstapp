import 'dart:collection';

import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_production_collection.dart';

class TeaCollectionModel {
  TeaProductionCollectionModel productions;
  final Map<String, Tea> _items = {};

  UnmodifiableListView<Tea> get items => UnmodifiableListView(_items.values);

  int get length => _items.length;

  void load() async {
    print('Loading tea collection');
    final user = await fetchUser();
    final userStashQuery =
        await user.reference.collection('teas_in_stash').getDocuments();
    final userStashContents = userStashQuery.documents.map((document)=> Tea(document, this.productions));
    print(
        'Got ${userStashContents.length} teas from db, adding to TeaCollectionModel');
    this._items.addAll(Map.fromIterable(userStashContents,
        key: (tea) => tea.id, value: (tea) => tea));
  }

  TeaCollectionModel(TeaProductionCollectionModel productions) {
    this.productions = productions;
    load();
  }
}
