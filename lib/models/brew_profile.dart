import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/models/brewing_vessel.dart';

class BrewProfile {
  String name;
  int nominalRatio; // expressed as integer n for ratio n:1 water:leaf
  int brewTemperatureCelsius; // expressed in degrees Celsius
  List<int> steepTimings;

  int get steeps => steepTimings.length;

  Map<String, dynamic> asMap() => {
        'name': name,
        'nominal_ratio': nominalRatio,
        'brew_temperature_celsius': brewTemperatureCelsius,
        'steep_timings': steepTimings
      };

  BrewProfile(this.name, this.nominalRatio, this.brewTemperatureCelsius,
      this.steepTimings);

  static BrewProfile fromJson(Map<String, dynamic> json) {
    List<int> intList = List<int>.from(json['steep_timings']);
    return BrewProfile(json['name'], json['nominal_ratio'],
        json['brew_temperature_celsius'], intList);
  }

  static BrewProfile getDefault() {
    List<int> sampleTimingList = [10, 5, 8, 10, 20, 30, 60];
    print('GENERATED DUMMY BREW PROFILE');
    return BrewProfile('Default', 15, 100, sampleTimingList);
  }

  double getDose(BrewingVessel vessel) {
    return vessel.volumeMilliliters / this.nominalRatio;
  }
}
