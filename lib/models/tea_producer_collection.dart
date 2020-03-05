import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_producer.dart';

class TeaProducerCollectionModel {
  final Map<String, TeaProducer> _items = {};

  UnmodifiableListView<TeaProducer> get items =>
      UnmodifiableListView(_items.values);

  int get length => _items.length;

  TeaProducer getId(String id) => _items[id];

  void load() async {
    print('Loading tea producers');
    final producerQuery =
        await Firestore.instance.collection('tea_producers').getDocuments();
    final producers =
        producerQuery.documents.map((document) => TeaProducer(document));
    print(
        'Got ${producers.length} producers from db, adding to TeaProducerCollectionModel');
    this._items.addAll(Map.fromIterable(producers,
        key: (producer) => producer.id, value: (producer) => producer));
  }

  TeaProducerCollectionModel() {
    load();
  }
}
