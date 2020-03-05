import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:firstapp/models/tea_producer_collection.dart';

class TeaProduction {
  String id;
  String name;
  int nominalWeightGrams;
  TeaProducer producer;
  int productionYear;

  Map<String, dynamic> asMap() => {
        'name': this.name,
        'nominal_weight_grams': this.nominalWeightGrams,
        'producer': this.producer.id,
        'production_year': this.productionYear
      };

  TeaProduction(DocumentSnapshot productionDocument,
      TeaProducerCollectionModel producers) {
    final data = productionDocument.data;

    this.id = productionDocument.documentID;
    this.name = data['name'];
    this.nominalWeightGrams = data['nominal_weight_grams'];
    this.producer = producers.getId(data['producer'].documentID);
    this.productionYear = data['production_year'];
  }
}
