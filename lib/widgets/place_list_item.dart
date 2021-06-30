import 'package:flutter/material.dart';

import '../screens/place_detail_screen.dart';

class PlaceListItem extends StatelessWidget {
  final String placeId;
  final String placeName;
  final String location;
  final double cost;
  final String imageUrl;

  final double borderRadius = 10;

  PlaceListItem({
    @required this.placeId,
    @required this.placeName,
    @required this.location,
    @required this.cost,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.borderRadius)),
      child: Container(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(this.borderRadius),
                      bottomLeft: Radius.circular(this.borderRadius)),
                  child: Image.network(
                    this.imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 6,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.placeName,
                      style: TextStyle(fontSize: 20),
                    ),
                    FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          this.location,
                          style: TextStyle(fontSize: 12),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '\$${this.cost.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            ' PPPD',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  Navigator.of(context).pushNamed(PlaceDetailScreen.routeName,arguments: this.placeId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
