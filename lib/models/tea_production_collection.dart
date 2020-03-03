import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:flutter/cupertino.dart';

class TeaProductionCollectionModel extends ChangeNotifier {
  final List<DocumentSnapshot> _items = [];

//  UnmodifiableListView<TeaProduction> get items => UnmodifiableListView(_items
//      .map((teaProductionDocument) => TeaProduction(teaProductionDocument)));

  int get length => _items.length;

  void load() async {
    print('Loading tea productions');
    final teaProductions = await fetchTeaProductions();
    print(
        'Got ${teaProductions.length} productions from db, adding to TeaProductionCollectionModel');
    this._items.addAll(teaProductions);
    print('Added teas to TeaProductionCollectionModel, notifying listeners');
    notifyListeners();
  }

  TeaProductionCollectionModel() {
    load();
  }
}
