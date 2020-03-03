import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:flutter/cupertino.dart';

class TeaProducerCollectionModel extends ChangeNotifier {
  final List<DocumentSnapshot> _items = [];

//  UnmodifiableListView<TeaProducer> get items => UnmodifiableListView(
//      _items.map((teaProducerDocument) => TeaProducer(teaProducerDocument)));

  int get length => _items.length;

  void load() async {
    print('Loading tea producers');
    final teaProducers = await fetchTeaProducers();
    print(
        'Got ${teaProducers.length} producers from db, adding to TeaProducerCollectionModel');
    this._items.addAll(teaProducers);
    print('Added teas to TeaProducerCollectionModel, notifying listeners');
    notifyListeners();
  }

  TeaProducerCollectionModel() {
    load();
  }
}
