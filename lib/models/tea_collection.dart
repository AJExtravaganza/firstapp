import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_production_collection.dart';
import 'package:flutter/cupertino.dart';

class TeaCollectionModel extends ChangeNotifier {
  final String dbCollectionName = 'teas_in_stash';
  TeaProductionCollectionModel productions;
  final Map<String, Tea> _items = {};

  UnmodifiableListView<Tea> get items => UnmodifiableListView(_items.values);

  int get length => _items.length;

  void fetch() async {
    print('Updating tea collection');
    final user = await fetchUser();
    final userStashQuery =
        await user.reference.collection(dbCollectionName).getDocuments();
    //TODO: try collection().snapshots for live updates
    final userStashContents = userStashQuery.documentChanges.map(
        (documentChange) => Tea.fromDocumentSnapshot(documentChange.document, this.productions));
    print(
        'Got ${userStashContents.length} updated teas from db, adding to TeaCollectionModel');
    userStashContents.forEach((tea) {print(tea.asString());});
    this._items.addAll(Map.fromIterable(userStashContents,
        key: (tea) => tea.id, value: (tea) => tea));

    notifyListeners();
  }

  Future<DocumentReference> put(Tea tea) async {
    final userSnapshot = await fetchUser();
    final newDocumentReference = await userSnapshot.reference.collection(dbCollectionName).add(tea.asMap());
    tea.id = newDocumentReference.documentID;
    _items[newDocumentReference.documentID] = tea;
    return newDocumentReference;
  }

  TeaCollectionModel(TeaProductionCollectionModel productions) {
    this.productions = productions;
  }
}
