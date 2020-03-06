import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:firstapp/models/tea_production_collection.dart';

enum TeaFormFactor { cake, brick, tuo, mushroomtuo, looseleaf }

class Tea {
  String id;
  int quantity;
  TeaProduction production;

  String asString() =>
      "${this.production.producer.shortName} ${this.production.productionYear} ${this.production.name}";

  Map<String, dynamic> asMap() =>
      {'quantity': this.quantity, 'production': production.id};

  Tea(this.quantity, this.production, [this.id]);

  static Tea fromDocumentSnapshot(DocumentSnapshot teaDocument, TeaProductionCollectionModel productions) {
    final data = teaDocument.data;
    return Tea(data['quantity'], productions.getById(data['production']), teaDocument.documentID);
  }

  bool operator ==(dynamic other) {
    return this.production.productionYear == other.production.year &&
        this.production.producer == other.production.producer &&
        this.production.name == other.production.name;
  }
}

class Terroir {
  // Implement later
}


