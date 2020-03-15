import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:firstapp/models/tea_production_collection.dart';

enum TeaFormFactor { cake, brick, tuo, mushroomtuo, looseleaf }

class Tea {
  int quantity;
  TeaProduction production;
  List<BrewProfile> brewProfiles = [];

  String get id => production.id;

  String asString() =>
      "${this.production.producer.shortName} ${this.production.productionYear} ${this.production.name}";

  Map<String, dynamic> asMap() {
    final brewProfileList = this.brewProfiles != null ? this.brewProfiles.map((brewProfile) => brewProfile.asMap()).toList() : [];
    return    {'quantity': this.quantity, 'production': production.id, 'brew_profiles': brewProfileList};

  }

  Tea(this.quantity, this.production, [this.brewProfiles = const [] ]) {
    if (this.brewProfiles.isEmpty) {
      this.brewProfiles = [];
    }
  }

  static Tea fromJson(Map<String, dynamic> json, TeaProductionCollectionModel productions) {
    List<BrewProfile> brewProfiles = List<BrewProfile>.from(json['brew_profiles'].map((json) => BrewProfile.fromJson(json)));
    return Tea(json['quantity'], productions.getById(json['production']), brewProfiles);
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


