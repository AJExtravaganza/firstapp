import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea.dart';
import 'package:flutter/cupertino.dart';

class TeaCollectionModel extends ChangeNotifier {
  final List<DocumentSnapshot> _items = [];

  UnmodifiableListView<Tea> get items => UnmodifiableListView(_items.map((teaDocument) => Tea(teaDocument)));
  int get length => _items.length;

  void load() async {
    print('Loading tea collection');
    final userStashContents = await fetchUserStashContents();
    print('Got ${userStashContents.length} teas from db, adding to TeaCollectionModel');
    this._items.addAll(userStashContents);
    print('Added teas to TeaCollectionModel, notifying listeners');
    notifyListeners();
  }

  TeaCollectionModel() {
    load();
  }

}
