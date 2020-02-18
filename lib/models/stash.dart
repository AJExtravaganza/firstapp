import 'dart:collection';

import 'package:firstapp/models/tea.dart';
import 'package:flutter/cupertino.dart';

class StashModel extends ChangeNotifier {
  final List<Tea> _items = getSampleTeaList();

  UnmodifiableListView<Tea> get items => UnmodifiableListView(_items);

  int get length => _items.length;

  void resetToSampleList() {
    _items.removeWhere((Tea tea) => true);
    _items.addAll(getSampleTeaList());
    notifyListeners();
  }
}
