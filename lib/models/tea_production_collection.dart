import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea_producer_collection.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TeaProductionCollectionModel extends ChangeNotifier {
  final String dbCollectionName = 'tea_productions';
  TeaProducerCollectionModel producers;
  Map<String, TeaProduction> _items = {};

  UnmodifiableListView<TeaProduction> get items =>
      UnmodifiableListView(_items.values);

  int get length => _items.length;

  TeaProduction getById(String id) => _items[id];

  void fetch() async {
    print('Updating tea productions');
    final productionQuery =
        await Firestore.instance.collection(dbCollectionName).getDocuments();
    final productions = productionQuery.documentChanges.map(
        (documentChange) => TeaProduction.fromDocumentSnapshot(documentChange.document, producers));
    print(
        'Got ${productions.length} updated productions from db, adding to TeaProductionCollectionModel');
    productions.forEach((production) {print(production.asString());});
    this._items.addAll(Map.fromIterable(productions,
        key: (production) => production.id, value: (production) => production));

    notifyListeners();
  }

  Future<DocumentReference> put(TeaProduction production) async {
    final newDocumentReference = await Firestore.instance.collection(dbCollectionName).add(production.asMap());
    production.id = newDocumentReference.documentID;
    _items[newDocumentReference.documentID] = production;
    return newDocumentReference;
  }

  TeaProductionCollectionModel(TeaProducerCollectionModel producers) {
    this.producers = producers;
  }
}

