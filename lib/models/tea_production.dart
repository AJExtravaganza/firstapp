import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:firstapp/models/tea_producer_collection.dart';

class TeaProduction {
  String id;
  String name;
  int nominalWeightGrams;
  TeaProducer producer;
  int productionYear;

  String asString() =>
      "${this.productionYear} ${this.producer.shortName} ${this.name}";

  Map<String, dynamic> asMap() => {
        'name': this.name,
        'nominal_weight_grams': this.nominalWeightGrams,
        'producer': this.producer.id,
        'production_year': this.productionYear
      };

  TeaProduction(this.name, this.nominalWeightGrams, this.producer, this.productionYear, [this.id]);

  static TeaProduction fromDocumentSnapshot (DocumentSnapshot productionDocument,
      TeaProducerCollectionModel producers) {
    final data = productionDocument.data;
    //TODO: Figure out why data['producer'] returns String rather than TeaProducer
    return TeaProduction(data['name'], data['nominal_weight_grams'], producers.getById(data['producer']), data['production_year'], productionDocument.documentID);
  }
}
