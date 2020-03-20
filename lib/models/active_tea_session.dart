import 'package:firstapp/main.dart';
import 'package:provider/provider.dart';

import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:flutter/widgets.dart';

class ActiveTeaSessionModel extends ChangeNotifier {
  TeaCollectionModel _teaCollectionModel;
  Tea _currentTea;
  BrewProfile _brewProfile;
  BrewingVessel brewingVessel;
  int _currentSteep = 0;

  get currentTea => _currentTea;

  get brewProfile =>
      _brewProfile != null ? _brewProfile : BrewProfile.getDefault();

  get currentSteep => _currentSteep;

  set currentTea(Tea newTea) {
    _currentTea = newTea;
    if (newTea != null) {
      _brewProfile = newTea.defaultBrewProfile;
    } else {
      _brewProfile = BrewProfile.getDefault();
    }
    _currentSteep = 0;

    notifyListeners();
  }

  set brewProfile(BrewProfile brewProfile) {
    _brewProfile = brewProfile;
    _currentSteep = 0;
    notifyListeners();
  }

  saveSteepTimeToBrewProfile(int currentSteep, Duration timeRemaining) async {
    brewProfile.steepTimings[currentSteep] = timeRemaining.inSeconds.floor();
    await _teaCollectionModel.push(currentTea);
  }

  set currentSteep(int value) {
    if (value >= 0 && value < brewProfile.steepTimings.length) {
      _currentSteep = value;
      notifyListeners();
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

  //Updates the ActiveTeaSession for change from no teas in stash to some teas in stash or vice versa
//  void refresh(BuildContext context) {
//    print("Checking for necessary changes to ActiveTeaSession...");
//    final teasInStash = Provider.of<TeaCollectionModel>(context, listen: false);
//    if (teasInStash.items.length > 0 &&
//        teasInStash.getUpdated(this._tea) == null) {
//      this.tea = teasInStash.items.first;
//      print('Active tea is now ${_tea.asString()}');
//    } else {
//      _tea = null;
//      _brewProfile = null;
//      notifyListeners();
//      print('Active tea is now null');
//    }
//  }

  ActiveTeaSessionModel(TeaCollectionModel teaCollectionModel) {
    _teaCollectionModel = teaCollectionModel;
    currentTea = null;
    _brewProfile = null;
    brewingVessel = getSampleVesselList().first;
  }
}
