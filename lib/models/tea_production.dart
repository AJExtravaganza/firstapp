import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_producer.dart';

class TeaProduction {
  String name;
  int nominalWeightGrams;
  TeaProducer producer;
  int productionYear;

  TeaProduction(DocumentReference productionDocument) {
//    final data = productionDocument.data;
    this.name = 'placeholderName';
    this.nominalWeightGrams = 100;
    this.producer = TeaProducer();
    this.productionYear = 2000;

//    final data = productionDocument.data;
//    this.name = data['name'];
//    this.nominalWeightGrams = data['nominal_weight_grams'];
//    this.producer = TeaProducer(data['producer']);
//    this.productionYear = data['production_year'];
  }
}