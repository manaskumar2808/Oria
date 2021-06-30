import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/place_provider.dart';

import '../widgets/place_list_item.dart';
import '../widgets/back_button.dart' as back_button;
import '../widgets/circular_loader.dart';

import '../utilities/string.dart';

class PlaceListScreen extends StatelessWidget {
  static const String routeName = '/place-list';

  @override
  Widget build(BuildContext context) {
    final String placeListType = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: back_button.BackButton(makeWhite: true,),
        title: Text(capitalize(placeListType),style: TextStyle(color: Colors.white),)
      ),
      body: Container(
        child: FutureBuilder(
          future: Provider.of<PlaceProvider>(context).filterDestinations(placeListType),
          builder: (context,placesSnapshot) => placesSnapshot.connectionState == ConnectionState.waiting ? 
          Center(
            child: CircularLoader(
              thickness: 1,
            ),
          ) :
          placesSnapshot.data == null || placesSnapshot.data.length == 0 ? 
          Center(
            child: Text('No recent $placeListType places available'),
          )
           : ListView.builder(
            itemCount: placesSnapshot.data.length,
            itemBuilder: (ctx, index) => PlaceListItem(
              placeId: placesSnapshot.data[index].placeId,
              placeName: placesSnapshot.data[index].placeName,
              location: placesSnapshot.data[index].location,
              imageUrl: placesSnapshot.data[index].imageUrl,
              cost: placesSnapshot.data[index].cost,
            ),
          ),
        ),
      ),
    );
  }
}
