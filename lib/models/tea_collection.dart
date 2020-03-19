import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_production_collection.dart';
import 'package:flutter/cupertino.dart';

class TeaCollectionModel extends ChangeNotifier {
  final String dbCollectionName = 'teas_in_stash';
  TeaProductionCollectionModel productions;
  Map<String, Tea> _items = {};

  UnmodifiableListView<Tea> get items {
    List<Tea> list = _items.values.toList();
    list.sort((Tea a, Tea b) => a.asString().compareTo(b.asString()));
    return UnmodifiableListView(list);
  }

  int get length => _items.length;

  Tea getUpdated(Tea tea) =>
      (tea != null && _items.containsKey(tea.id)) ? _items[tea.id] : null;

  Future<void> put(Tea tea) async {
    if (_items.containsKey(tea.id)) {
      _items[tea.id].quantity += tea.quantity;
    } else {
      _items[tea.id] = tea;
    }

    notifyListeners();
    await push(tea);
  }

  Future<void> putBrewProfile(BrewProfile brewProfile, Tea tea) async {
    if (_items[tea.id]
            .brewProfiles
            .where((existingBrewProfile) =>
                existingBrewProfile.name == brewProfile.name)
            .length >
        0) {
      throw Exception(
          'A brew profile named ${brewProfile.name} already exists for this tea');
    }

    _items[tea.id].brewProfiles.add(brewProfile);
    await push(tea);
    notifyListeners();
  }

  Future<void> updateBrewProfile(BrewProfile brewProfile, Tea tea) async {
    try {
      _items[tea.id].brewProfiles.remove(_items[tea.id]
          .brewProfiles
          .singleWhere((existingBrewProfile) =>
              existingBrewProfile.name == brewProfile.name));
    } catch (err) {
      //ignore if not present
    }
    putBrewProfile(brewProfile, tea);
  }

  Future<void> push(Tea tea) async {
    final userSnapshot =
        await fetchUser(); //TODO start using static state from enclosing auth class
    final teasCollection = await userSnapshot.reference.collection(dbCollectionName);
    await teasCollection.document(tea.id).setData(tea.asMap());
    notifyListeners();
  }

  Future subscribeToUpdates() async {
    final userSnapshot = await fetchUser();
    print('Subscribing to Tea updates');
    final updateStream = userSnapshot.reference.collection(dbCollectionName).snapshots();
    updateStream.listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((documentChange) {
        final document = documentChange.document;
        this._items[document.documentID] =
            Tea.fromDocumentSnapshot(document, productions);
        print('Got change to Tea ${document.documentID}');
        notifyListeners();
      });
    });
  }

  TeaCollectionModel(TeaProductionCollectionModel productions) {
    this.productions = productions;
    subscribeToUpdates();
  }
}
