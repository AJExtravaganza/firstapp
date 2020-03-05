import 'package:cloud_firestore/cloud_firestore.dart';

class TeaProducer {
  String id;
  String name;
  String shortName;

  TeaProducer(DocumentSnapshot producerDocument) {
    final data = producerDocument.data;
    this.name = data['name'];
    this.shortName = data['short_name'];
    this.id = producerDocument.documentID;
  }

  bool operator ==(dynamic other) {
    return this.name == other.name;
  }
}
