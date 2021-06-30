import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/place_list_screen.dart';
import '../screens/place_detail_screen.dart';

import '../providers/place_provider.dart';

import '../widgets/destination_item.dart';
import '../widgets/circular_loader.dart';

import '../utilities/string.dart';

class DestinationList extends StatelessWidget {
  final String destinationType;

  DestinationList({this.destinationType});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  capitalize(this.destinationType),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(PlaceListScreen.routeName,
                        arguments: this.destinationType);
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 250,
            child: FutureBuilder(
              future: Provider.of<PlaceProvider>(context)
                  .filterDestinations(this.destinationType),
              builder: (context, placesSnapshot) => placesSnapshot
                          .connectionState ==
                      ConnectionState.waiting
                  ? Center(
                      child: CircularLoader(
                        thickness: 1,
                      ),
                    )
                  : placesSnapshot.data == null ||
                          placesSnapshot.data.length == 0
                      ? Center(
                          child: Text('No ${this.destinationType} destinations avialable',style: TextStyle(color: Colors.red),),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: placesSnapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    PlaceDetailScreen.routeName,
                                    arguments:
                                        placesSnapshot.data[index].placeId);
                              },
                              child: DestinationItem(
                                placeId: placesSnapshot.data[index].placeId,
                                placeName: placesSnapshot.data[index].placeName,
                                location: placesSnapshot.data[index].location,
                                imageUrl: placesSnapshot.data[index].imageUrl,
                                isUWHS: placesSnapshot.data[index].isUWHS,
                              ),
                            );
                          }),
            ),
          ),
        ],
      ),
    );
  }
}
