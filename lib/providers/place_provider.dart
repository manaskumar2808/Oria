import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/place.dart';

class PlaceProvider with ChangeNotifier {
  List<Place> _places = [];

  Future<List<Place>> get places async {
    return [...this._places];
  }

  Place findById(String id) {
    return this._places.firstWhere((place) => place.placeId == id);
  }

  Future<List<Place>> filterDestinations(String destinationType) async {
    await this.fetchAndSetPlaces();
    switch (destinationType) {
      case 'expensive':
        return this._places.where((place) => place.cost >= 100).toList();
        break;
      case 'adventurous':
        return this._places.where((place) => place.elevation >= 1000).toList();
        break;
      case 'easy':
        return this
            ._places
            .where((place) => place.cost < 100 && place.elevation < 1000)
            .toList();
        break;
      default:
        return places;
    }
  }

  Future<void> fetchAndSetPlaces() async {
    final places = await Firestore.instance.collection('places').getDocuments();

    List<Place> loadedPlaces = [];
    places.documents.forEach((document) {
      var place = document.data;
      loadedPlaces.add(Place(
        placeId: document.documentID,
        placeName: place['placeName'],
        location: place['location'],
        cost: place['cost'],
        elevation: place['elevation'],
        imageUrl: place['imageUrl'],
        description: place['description'],
        isUWHS: place['isUWHS'],
      ));
    });

    this._places = loadedPlaces;
  }

  Future<void> addPlace({
    String location,
    String placeName,
    String description,
    File image,
    double cost,
    double elevation,
    String imageUrl,
    bool isUWHS,
  }) async {
    final placeRef = Firestore.instance.collection('places').document();
    final placeId = placeRef.documentID;

    if(image != null){
      final ref = FirebaseStorage.instance.ref().child('place_image').child(placeId + '.jpg');
      await ref.putFile(image).onComplete;
      imageUrl = await ref.getDownloadURL();
    }
    
    await placeRef.setData({
      'placeName': placeName,
      'location': location,
      'imageUrl': imageUrl,
      'description': description,
      'cost': cost,
      'elevation': elevation,
      'isUWHS': isUWHS,
    });

    final newPlace = Place(
      placeId: placeId,
      placeName: placeName,
      location: location,
      description: description,
      imageUrl: imageUrl,
      cost: cost,
      elevation: elevation,
      isUWHS: isUWHS,
    );

    this._places.add(newPlace);
    notifyListeners();
  }

  Future<void> updatePlace(
    String id, {
    String newPlaceName = '',
    String newLocation = '',
    String newDescription = '',
    String newImageUrl = '',
    double newCost = 0.0,
    double newElevation = 0.0,
    bool newIsUWHS,
  }) async {
    var placeIndex = this._places.indexWhere((place) => place.placeId == id);
    final oldPlace = this._places[placeIndex];

    this._places[placeIndex].placeName =
        newPlaceName.isEmpty ? oldPlace.placeName : newPlaceName;
    this._places[placeIndex].location =
        newLocation.isEmpty ? oldPlace.location : newLocation;
    this._places[placeIndex].description =
        newDescription.isEmpty ? oldPlace.description : newDescription;
    this._places[placeIndex].imageUrl =
        newImageUrl.isEmpty ? oldPlace.imageUrl : newImageUrl;
    this._places[placeIndex].cost = newCost == 0.0 ? oldPlace.cost : newCost;
    this._places[placeIndex].elevation =
        newElevation == 0.0 ? oldPlace.elevation : newElevation;
    this._places[placeIndex].isUWHS =
        newIsUWHS == null ? oldPlace.isUWHS : newIsUWHS;

    await Firestore.instance.collection('places').document(id).updateData({
      'placeName': this._places[placeIndex].placeName,
      'location': this._places[placeIndex].location,
      'description': this._places[placeIndex].description,
      'imageUrl': this._places[placeIndex].imageUrl,
      'cost': this._places[placeIndex].cost,
      'elevation': this._places[placeIndex].elevation,
      'isUWHS': this._places[placeIndex].isUWHS,
    });

    notifyListeners();
  }

  Future<void> removePlace(String id) async {
    await Firestore.instance.collection('places').document(id).delete();
    this._places.removeWhere((place) => place.placeId == id);
    notifyListeners();
  }
}
