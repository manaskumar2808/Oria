import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/place_provider.dart';

import '../widgets/back_button.dart' as back_button;

class PlaceDetailScreen extends StatelessWidget {
  static const String routeName = '/place-detail';

  final double _borderRadius = 20;
  final double _thickness = 1;

  @override
  Widget build(BuildContext context) {
    final currentPlaceId = ModalRoute.of(context).settings.arguments;
    final currentPlace =
        Provider.of<PlaceProvider>(context).findById(currentPlaceId);

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Image.network(
              currentPlace.imageUrl,
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.black26,
                  Colors.white.withOpacity(0.0),
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
              )),
            ),
            Positioned(
              top: 40,
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    back_button.BackButton(
                      makeWhite: true,
                    ),
                    Container(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            currentPlace.placeName,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            currentPlace.location,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 300),
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(this._borderRadius),
                  topRight: Radius.circular(this._borderRadius),
                ),
              ),
              child: ListView(
                children: <Widget>[

                  Text(currentPlace.placeName,style: TextStyle(fontSize: 23),),
                  Text(currentPlace.location,style: TextStyle(fontSize: 17),),
                  Divider(
                    thickness: this._thickness,
                  ),
                  if(currentPlace.isUWHS)
                    Text('UNESCO World Heritage Site',style: TextStyle(fontSize: 20,color: Colors.red),),
                  if(currentPlace.isUWHS)
                    Divider(
                      thickness: this._thickness,
                    ),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(currentPlace.description,style: TextStyle(fontSize: 15),),
                  Divider(
                    thickness: this._thickness,
                  ),
                  Row(
                    children: <Widget>[
                      Text('Cost ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), 
                      Text('\$${currentPlace.cost}',style: TextStyle(fontSize: 20),),
                    ],
                  ),
                  Divider(
                    thickness: this._thickness,
                  ),
                  Row(
                    children: <Widget>[
                      Text('Elevation ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), 
                      Text('${currentPlace.elevation.toStringAsFixed(0)} metres',style: TextStyle(fontSize: 20),),
                    ],
                  ),
                  Divider(
                    thickness: this._thickness,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
