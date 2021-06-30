import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

import '../validators/place_validators.dart';

import '../widgets/circular_loader.dart';

class PlaceForm extends StatefulWidget {
  final void Function({
    BuildContext ctx,
    String placeName,
    String location,
    String description,
    String imageUrl,
    File image,
    double cost,
    double elevation,
    bool isUWHS,
  }) submitPlace;

  bool _isLoading = false;

  PlaceForm(
    this.submitPlace,
    this._isLoading,
  );

  @override
  _PlaceFormState createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  bool _showInfoForm = false;
  final _form = GlobalKey<FormState>();

  String _type = '';
  var _imageUrlController = TextEditingController();

  // place fields
  String placeName = '';
  String location = '';
  String description = '';
  File image;
  String imageUrl = '';
  double cost = 0.0;
  double elevation = 0.0;
  bool isUWHS = false;

  void _submitForm() {
    setState(() {
      this.widget._isLoading = true;
    });

    var isValid = this._form.currentState.validate();
    if (!isValid) {
      setState(() {
        this.widget._isLoading = false;
      });
      return;
    }
    this._form.currentState.save();
    this.widget.submitPlace(
          ctx: context,
          placeName: this.placeName,
          location: this.location,
          description: this.description,
          imageUrl: this.imageUrl,
          image: this.image,
          cost: this.cost,
          elevation: this.elevation,
          isUWHS: this.isUWHS,
        );    
  }

  void _mediaType() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    this._type = 'image';
                    this._setMedia();
                  });
                },
                child: Text(
                  'Take from camera',
                  style: TextStyle(color: Colors.blue),
                )),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  this._type = 'gallery';
                  this._setMedia();
                });
              },
              child: Text(
                'Choose from gallery',
                style: TextStyle(color: Colors.black),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                this._setImageUrl();
              },
              child: Text(
                'provide URL',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setImageUrl() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: this._imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Enter Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: .5),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    this.imageUrl = this._imageUrlController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('add URL',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setMedia() async {
    final picker = ImagePicker();
    var imageFile;

    switch (this._type) {
      case 'image':
        imageFile = await picker.getImage(
          source: ImageSource.camera,
          maxWidth: 600,
        );
        break;
      case 'gallery':
        imageFile = await picker.getImage(
          source: ImageSource.gallery,
          maxWidth: 600,
        );
        break;
      default:
        return;
    }

    setState(() {
      this.image = File(imageFile.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    setState(() {
      this.imageUrl = savedImage.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return this._showInfoForm
        ? Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: this._form,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this._showInfoForm = false;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: ValueKey('placeName'),
                      decoration: InputDecoration(
                        labelText: 'Place Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => placeNameValidator(value),
                      onSaved: (newValue) {
                        this.placeName = newValue;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: ValueKey('location'),
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => locationValidator(value),
                      onSaved: (newValue) {
                        this.location = newValue;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: ValueKey('description'),
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => descriptionValidator(value),
                      onSaved: (newValue) {
                        this.description = newValue;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: ValueKey('cost'),
                      decoration: InputDecoration(
                        labelText: 'Cost(in American dollars)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => costValidator(value),
                      onSaved: (newValue) {
                        this.cost = double.parse(newValue);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: ValueKey('elevation'),
                      decoration: InputDecoration(
                          labelText: 'Elevation(in metres)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      validator: (value) => elevationValidator(value),
                      onSaved: (newValue) {
                        this.elevation = double.parse(newValue);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text('   UNESCO World Heritage Site '),
                        Checkbox(
                          key: ValueKey('isUWHS'),
                          tristate: false,
                          activeColor: Colors.red,
                          checkColor: Colors.white,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          value: this.isUWHS,
                          onChanged: (value) {
                            setState(() {
                              this.isUWHS = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: this._submitForm,
                        child: this.widget._isLoading ? CircularProgressIndicator() : Text(
                          'Submit Destination',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.black,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : this.imageUrl == null || this.imageUrl.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.black54,
                    ],
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    IconButton(
                      onPressed: this._mediaType,
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                      iconSize: 80,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            this._showInfoForm = true;
                          });
                        },
                        child: Text('Add Place Information',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.black,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    )
                  ],
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 56,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: CircularLoader(
                        thickness: 1,
                      ),
                    ),
                    GestureDetector(
                        onTap: this._mediaType,
                        child: this.image == null
                            ? Image.network(
                                this.imageUrl,
                                fit: BoxFit.cover,
                                height: double.infinity,
                              )
                            : Image.file(
                                this.image,
                                fit: BoxFit.cover,
                                height: double.infinity,
                              )
                      ),
                    Positioned(
                      bottom: 20,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              this._showInfoForm = true;
                            });
                          },
                          child: Text('Add Place Information',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          color: Colors.black,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
