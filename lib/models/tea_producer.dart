import 'package:cloud_firestore/cloud_firestore.dart';

class TeaProducer {
  String name;
  String shortName;

  TeaProducer() {
//    final data = producerDocument.data;
    this.name = 'placeholderProducerName';
    this.shortName = 'PPN';
  }

//  TeaProducer(DocumentSnapshot producerDocument) {
//    final data = producerDocument.data;
//    this.name = data['name'];
//    this.shortName = data['short_name'] ? data['short_name'] : this.name;
//  }

  bool operator ==(dynamic other) {
    return this.name == other.name;
  }
}