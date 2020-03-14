import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeaProducerCollectionModel extends ChangeNotifier {
  final String dbCollectionName = 'tea_producers';
  final Map<String, TeaProducer> _items = {};

  UnmodifiableListView<TeaProducer> get items =>
      UnmodifiableListView(_items.values);

  int get length => _items.length;

  TeaProducer getById(String id) => _items[id];

  Future<void> fetch() async {
    print('Updating tea producers');
    final producerQuery =
        await Firestore.instance.collection(dbCollectionName).getDocuments();

    final producers = producerQuery.documentChanges.map((documentChange) =>
        TeaProducer.fromDocumentSnapshot(documentChange.document));
    print(
        'Got ${producers.length} updated producers from db, adding to TeaProducerCollectionModel');
    this._items.addAll(Map.fromIterable(producers,
        key: (producer) => producer.id, value: (producer) => producer));

    notifyListeners();
  }

  Future<DocumentReference> put(TeaProducer producer) async {
    final newDocumentReference = await Firestore.instance
        .collection(dbCollectionName)
        .add(producer.asMap());
    producer.id = newDocumentReference.documentID;
    _items[newDocumentReference.documentID] = producer;
    return newDocumentReference;
  }

  TeaProducerCollectionModel() {}
}
