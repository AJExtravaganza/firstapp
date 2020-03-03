import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:provider/provider.dart';

class BrewProfile {
  Tea tea;
  int nominalRatio; // expressed as integer n for ratio n:1 water:leaf
  int brewTemperature; // expressed in degrees Celsius
  List<int> steepTimings;
  int steeps;

  BrewProfile(
      this.tea, this.nominalRatio, this.brewTemperature, this.steepTimings) {
    this.steeps = steepTimings.length;
  }

  double getDose(BrewingVessel vessel) {
    return vessel.volumeMilliliters / this.nominalRatio;
  }
}

List<BrewProfile> getSampleBrewProfileList(context) {
  List<BrewProfile> brewProfiles = [];
  List<int> sampleTimingList = [10, 5, 8, 10, 20, 30, 60];

  for (final tea in Provider.of<TeaCollectionModel>(context).items) {
    brewProfiles.add(BrewProfile(tea, 15, 100, sampleTimingList));
  }

  return brewProfiles;
}
