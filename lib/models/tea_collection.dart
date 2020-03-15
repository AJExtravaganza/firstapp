import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_production_collection.dart';
import 'package:flutter/cupertino.dart';

class TeaCollectionModel extends ChangeNotifier {
  final String dbFieldName = 'teas_in_stash';
  TeaProductionCollectionModel productions;
  Map<String, Tea> _items = {};

  UnmodifiableListView<Tea> get items {
    List<Tea> list = _items.values.toList();
    list.sort((Tea a, Tea b) => a.asString().compareTo(b.asString()));
    return UnmodifiableListView(list);
  }

  int get length => _items.length;

  Tea getUpdated(Tea tea) => _items[tea.id];

  Future<void> sync() async {
    await push();
    await fetch();
  }

  Future<void> fetch() async {
    print('Updating tea collection');
    final user = await fetchUser();
    final userStashContents = user.data[dbFieldName];

    if (userStashContents != null && userStashContents.length > 0) {
      this._items = Map.fromIterable(userStashContents.values,
        key: (teaJson) => teaJson['production'], value: (teaJson) => Tea.fromJson(teaJson, productions));
  }

    notifyListeners();
  }

  Future<void> put(Tea tea) async {

    if (_items.containsKey(tea.id)) {
      _items[tea.id].quantity += tea.quantity;
    } else {
      _items[tea.id] = tea;
    }

    notifyListeners();
    await push();
  }

  Future<void> putBrewProfile(BrewProfile brewProfile, Tea tea) async {
    _items[tea.id].brewProfiles.add(brewProfile);

    notifyListeners();
    await push();
  }

  Future<void> push() async {
    final userSnapshot = await fetchUser();
    Map<String, dynamic> userData = userSnapshot.data;
    userData[dbFieldName] = {};
    _items.values.forEach((tea) {userData[dbFieldName][tea.id] = tea.asMap();});

    notifyListeners();
    await userSnapshot.reference.setData(userData);
    final us2 = await fetchUser();
  }

  TeaCollectionModel(TeaProductionCollectionModel productions) {
    this.productions = productions;
  }
}
