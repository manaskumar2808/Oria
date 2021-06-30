import 'package:flutter/foundation.dart';

import '../models/sight.dart';

class SightProvider with ChangeNotifier {
  List<Sight> _sights;

  List<Sight> get sights {
    return [...this._sights];
  }

  Sight findById(String id) {
    return this._sights.firstWhere((sight) => sight.sightId == id);
  }

  void addSight(Sight sight) {
    this._sights.add(sight);
    notifyListeners();
  }

  void updateSight(String id, Sight newSight) {
    var sightIndex = this._sights.indexWhere((sight) => sight.sightId == id);
    this._sights[sightIndex] = newSight;
    notifyListeners();
  }

  void removeSight(String id) {
    this._sights.removeWhere((sight) => sight.sightId == id);
    notifyListeners();
  }
  
}
