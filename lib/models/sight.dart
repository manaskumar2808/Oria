import 'package:flutter/foundation.dart';

class Sight {
  final String sightId;
  final String sightName;
  final String cost;
  final String description;
  final String speciality;
  final String imageUrl;
  final String placeId;

  Sight({
    @required this.sightId,
    @required this.sightName,
    @required this.cost,
    @required this.description,
    @required this.speciality,
    @required this.imageUrl,
    @required this.placeId,
  });
}
