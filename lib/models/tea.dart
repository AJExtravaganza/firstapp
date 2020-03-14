import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:firstapp/models/tea_production_collection.dart';

enum TeaFormFactor { cake, brick, tuo, mushroomtuo, looseleaf }

class Tea {
  String id;
  int quantity;
  TeaProduction production;
  List<BrewProfile> brewProfiles;

  String asString() =>
      "${this.production.producer.shortName} ${this.production.productionYear} ${this.production.name}";

  Map<String, dynamic> asMap() =>
      {'quantity': this.quantity, 'production': production.id, 'brew_profiles': this.brewProfiles};

  Tea(this.quantity, this.production, [this.id, this.brewProfiles]);

  static Tea fromDocumentSnapshot(DocumentSnapshot teaDocument, TeaProductionCollectionModel productions) {
    final data = teaDocument.data;
    List<BrewProfile> brewProfiles = [];
    try {
      brewProfiles = teaDocument.data['brew_profiles'].map((document) => BrewProfile.fromDocumentSnapshot(document));
    } catch (err) {
      brewProfiles = [];
    }

    return Tea(data['quantity'], productions.getById(data['production']), teaDocument.documentID, brewProfiles);
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


