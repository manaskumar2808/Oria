import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/place_provider.dart';

import '../widgets/back_button.dart' as back_button;
import '../widgets/place_form.dart';

class PlaceFormScreen extends StatefulWidget {
  static const String routeName = '/place-form';

  @override
  _PlaceFormScreenState createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  bool _isLoading = false;

  void _showDialog(
      {BuildContext ctx, String title, String message, bool hasError = false}) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title,
          style: TextStyle(color: hasError ? Colors.red : Colors.green),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: hasError ? Colors.red : Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  void submitPlace({
    BuildContext ctx,
    String placeName = '',
    String location = '',
    String description = '',
    File image,
    String imageUrl = '',
    double cost = 0.0,
    double elevation = 0.0,
    bool isUWHS = false,
  }) async {
    try {
      await Provider.of<PlaceProvider>(context, listen: false).addPlace(
        placeName: placeName,
        location: location,
        description: description,
        image: image,
        imageUrl: imageUrl,
        cost: cost,
        elevation: elevation,
        isUWHS: isUWHS,
      );
      this._showDialog(
        ctx: ctx,
        title: "Congratulations!",
        message: "You have successfully added a new destination.",
        hasError: false,
      );
      setState(() {
        this._isLoading = false;
      });
    } catch (error) {
      var errorMessage =
          "Can't add the destination at the moment. Please try again later...";
      this._showDialog(
        ctx: ctx,
        title: "An Error Occured!",
        message: errorMessage,
        hasError: true,
      );
      setState(() {
        this._isLoading = false;
      });
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: back_button.BackButton(
          crossIcon: true,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Add Place'),
      ),
      body: PlaceForm(this.submitPlace, this._isLoading),
    );
  }
}
