import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:firstapp/models/tea_production_collection.dart';

enum TeaFormFactor { cake, brick, tuo, mushroomtuo, looseleaf }

class Tea {
  String id;
  int quantity;
  TeaProduction production;

  String asString() =>
      "${this.production.productionYear} ${this.production.producer.shortName} ${this.production.name}";

  Map<String, dynamic> asMap() =>
      {'quantity': this.quantity, 'production': production.id};

  Tea(DocumentSnapshot teaDocument, TeaProductionCollectionModel productions) {
    final data = teaDocument.data;

    this.quantity = data['quantity'];
    this.production = productions.getId(data['production'].documentID.trim());
    this.id = teaDocument.documentID;
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

//List<Tea> getSampleTeaList() {
//  return [
//    Tea(2007, Producer('Xizihao', 'XZH'), Production("Dingji Gushu")),
//    Tea(2005, Producer('Menghai Dayi Tea Factory', 'Dayi'),
//        Production("502-7542")),
//    Tea(2005, Producer('Menghai Dayi Tea Factory', 'Dayi'),
//        Production("504-8542")),
//    Tea(2009, Producer('Menghai Dayi Tea Factory', 'Dayi'),
//        Production("901-7542")),
//    Tea(2007, Producer('Wisteria'), Production("Honyin (Red Mark)")),
//    Tea(2007, Producer('Wisteria'), Production("Lanyin (Blue Mark)")),
//    Tea(2003, Producer('Wisteria'), Production("Ziyin Youle (Purple Mark)")),
//    Tea(2003, Producer('Wisteria'), Production("Ziyin Nannuo (Blue Mark)")),
//    Tea(2001, Producer('Xiaguan'), Production("8653 Tiebing")),
//    Tea(2013, Producer('Xiaguan'), Production("Love Forever (Paper Tong)")),
//    Tea(2004, Producer('Xiaguan'), Production("Jinsi")),
//  ];
//}
