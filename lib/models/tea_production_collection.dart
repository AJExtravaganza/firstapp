import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea_producer_collection.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TeaProductionCollectionModel {
  TeaProducerCollectionModel producers;
  Map<String, TeaProduction> _items = {};

  UnmodifiableListView<TeaProduction> get items =>
      UnmodifiableListView(_items.values);

  int get length => _items.length;

  TeaProduction getId(String id) => _items[id];

  void load() async {
    print('Loading tea productions');
    final productionQuery =
        await Firestore.instance.collection('tea_productions').getDocuments();
    final productions = productionQuery.documents
        .map((document) => TeaProduction(document, producers));
    print(
        'Got ${productions.length} productions from db, adding to TeaProductionCollectionModel');
    this._items.addAll(Map.fromIterable(productions,
        key: (production) => production.id, value: (production) => production));
  }

  TeaProductionCollectionModel(TeaProducerCollectionModel producers) {
    this.producers = producers;
    load();
  }
}
