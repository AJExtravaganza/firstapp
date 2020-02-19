import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:flutter/widgets.dart';

class ActiveTeaSessionModel extends ChangeNotifier {
  Tea tea;
  BrewProfile brewProfile;
  BrewingVessel brewingVessel;
  int _currentSteep = 0;

  get currentSteep => _currentSteep;

  set currentSteep(int value) {
    if (value > 0 && value < brewProfile.steepTimings.length) {
      _currentSteep = value;
    } else {
      throw Exception(
          'No steepTimings element at index $value in active BrewProfile');
    }
  }

  decrementSteep() {
    currentSteep -= 1;
  }

  incrementSteep() {
    currentSteep += 1;
  }

  ActiveTeaSessionModel() {
//    FAKE INITIALIZERS - REMOVE ONCE TEA/VESSEL/PROFILE SELECTION IS IMPLEMENTED
  tea = getSampleTeaList().first;
  brewProfile = getSampleBrewProfileList().first;
  assert (brewProfile.tea == tea);
  brewingVessel = getSampleVesselList().first;
  }
}
