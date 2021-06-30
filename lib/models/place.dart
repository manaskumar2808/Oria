import 'package:flutter/foundation.dart';

class Place {
  String placeName;
  String placeId;
  String location;
  double cost; // per person per day
  String description;
  double elevation; //in metres
  bool isUWHS; //UNESCO WORLD HERITAGE SITE
  String imageUrl;

  Place({
    @required this.placeId,
    @required this.placeName,
    @required this.location,
    @required this.cost,
    @required this.description,
    this.elevation,
    this.isUWHS,
    @required this.imageUrl,
  });
}
