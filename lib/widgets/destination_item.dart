import 'package:flutter/material.dart';

import '../models/place.dart';

import '../providers/place_provider.dart';

class DestinationItem extends StatelessWidget {
  final String placeId;
  final String placeName;
  final String location;
  final String imageUrl;
  final bool isUWHS;

  final double imageHeight = 250;
  final double imageWidth = 180;
  final double imageBorderRadius = 10;

  DestinationItem({
      @required this.placeId,
      @required this.placeName,
      @required this.location,
      @required this.imageUrl,
      this.isUWHS = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: .5, color: Colors.grey),
        borderRadius: BorderRadius.circular(this.imageBorderRadius),
      ),
      height: this.imageHeight,
      width: this.imageWidth,
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(this.imageBorderRadius),
              child: Image.network(
                this.imageUrl,
                fit: BoxFit.cover,
                height: this.imageHeight,
                width: this.imageWidth,
              )),
          Container(
            height: this.imageHeight,
            width: this.imageWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(this.imageBorderRadius),
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.black54,
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  placeName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    location,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          if(isUWHS)
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(100)
              ),
              child: Icon(Icons.check_circle,color: Colors.red,size: 20,)
            ),
          )
        ],
      ),
    );
  }
}
