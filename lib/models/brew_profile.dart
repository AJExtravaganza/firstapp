import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:provider/provider.dart';

class BrewProfile {
//  Tea tea;
  int nominalRatio; // expressed as integer n for ratio n:1 water:leaf
  int brewTemperatureCelsius; // expressed in degrees Celsius
  List<int> steepTimings;
  int steeps;

  BrewProfile(this.nominalRatio, this.brewTemperatureCelsius, this.steepTimings) {
    this.steeps = steepTimings.length;
  }

  static BrewProfile fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data;
    return getDefault();
  }

  static BrewProfile getDefault() {
    List<int> sampleTimingList = [10, 5, 8, 10, 20, 30, 60];
    print('GENERATED DUMMY BREW PROFILE');
    return BrewProfile(15, 100, sampleTimingList);
  }

  double getDose(BrewingVessel vessel) {
    return vessel.volumeMilliliters / this.nominalRatio;
  }
}
//
//List<BrewProfile> getSampleBrewProfileList(context) {
//  List<BrewProfile> brewProfiles = [];
//  List<int> sampleTimingList = [10, 5, 8, 10, 20, 30, 60];
//
//  for (final tea in Provider.of<TeaCollectionModel>(context).items) {
//    brewProfiles.add(BrewProfile(tea, 15, 100, sampleTimingList));
//  }
//
//  return brewProfiles;
//}
