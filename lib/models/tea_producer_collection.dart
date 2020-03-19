import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeaProducerCollectionModel extends ChangeNotifier {
  final String dbCollectionName = 'tea_producers';
  final Map<String, TeaProducer> _items = {};

  UnmodifiableListView<TeaProducer> get items {
    List<TeaProducer> list = _items.values.toList();
    list.sort((TeaProducer a, TeaProducer b) => a.asString().compareTo(b.asString()));
    return UnmodifiableListView(list);
  }

  int get length => _items.length;

  TeaProducer getById(String id) => _items[id];


  Future<DocumentReference> put(TeaProducer producer) async {
    final newDocumentReference = await Firestore.instance
        .collection(dbCollectionName)
        .add(producer.asMap());
    producer.id = newDocumentReference.documentID;
    _items[newDocumentReference.documentID] = producer;
    return newDocumentReference;
  }

  TeaProducerCollectionModel() {
    print('Subscribing to TeaProducer updates');
    final updateStream = Firestore.instance.collection(dbCollectionName).snapshots();
    updateStream.listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((documentChange) {
        final document = documentChange.document;
        this._items[document.documentID] = TeaProducer.fromDocumentSnapshot(document);
        print('Got change to TeaProducer ${document.documentID}');
        notifyListeners();
      });
    });
  }
}
