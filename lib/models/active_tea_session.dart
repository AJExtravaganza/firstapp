import 'package:provider/provider.dart';


import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:flutter/widgets.dart';

class ActiveTeaSessionModel extends ChangeNotifier {
  Tea tea;
  BrewProfile _brewProfile;
  BrewingVessel brewingVessel;
  int _currentSteep = 0;

  get currentSteep => _currentSteep;
  get brewProfile => _brewProfile != null ? _brewProfile : BrewProfile.getDefault();

  set currentSteep(int value) {
    if (value > 0 && value < brewProfile.steepTimings.length) {
      _currentSteep = value;
    } else {
      throw Exception(
          'No steepTimings element at index $value in active BrewProfile');
    }
  }

  resetSession([Tea tea]) {
    if (tea != null) {
      this.tea = tea;
    }
    _currentSteep = 0;
  }

  decrementSteep() {
    currentSteep -= 1;
  }

  incrementSteep() {
    currentSteep += 1;
  }

  ActiveTeaSessionModel(TeaCollectionModel teaCollectionModel) {
    try {
      tea = teaCollectionModel.items.first;
      _brewProfile = tea.brewProfiles.first;
    } catch (err) {
      tea = null;
      _brewProfile = null;
    }

    brewingVessel = getSampleVesselList().first;
  }
}
