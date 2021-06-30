import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oria/providers/feed_provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../validators/feed_validators.dart';

class FeedForm extends StatefulWidget {

  String feedId;
  String location;
  String description;
  File image;
  String imageUrl;
  bool isUpdating;

  FeedForm({
    this.feedId,
    this.location,
    this.description,
    this.image,
    this.imageUrl,
    this.isUpdating = false,
  });

  @override
  _FeedFormState createState() => _FeedFormState();
}

class _FeedFormState extends State<FeedForm> {
  String _type;

  //imageUrl controller
  var _imageUrlController = TextEditingController();

  // fields

  // loader
  bool _isLoading = false;

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    this._imageUrlController.dispose();
    super.dispose();
  }

  void _showDialog(String title, String message, {bool success = true}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          title,
          style: TextStyle(color: success ? Colors.green : Colors.red),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'done',
              style: TextStyle(color: success ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      this._isLoading = true;
    });
    if (this.widget.image == null && (this.widget.imageUrl == null || this.widget.imageUrl.isEmpty)) {
      setState(() {
        this._isLoading = false;
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please provide an Image!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final isValid = this._form.currentState.validate();
    if (!isValid) {
      setState(() {
        this._isLoading = false;
      });
      return;
    }
    this._form.currentState.save();

    if (this.widget.isUpdating) {
      try {
        await Provider.of<FeedProvider>(context, listen: false).updateFeed(
          this.widget.feedId,
          newLocation: this.widget.location,
          newImage: this.widget.image,
          newImageUrl: this.widget.imageUrl,
          newDescription: this.widget.description,
        );
        setState(() {
          this._isLoading = false;
        });
        this._showDialog("Congratulations", "You have successfully updated the post!");
      } catch (error) {
        final errorMessage =  "Error while updating the post! Please try again later...";
        setState(() {
          this._isLoading = false;
        });
        this._showDialog("An error occured", errorMessage, success: false);
        throw error;
      }
    } else {
      try {
        await Provider.of<FeedProvider>(context, listen: false).addFeed(
          postLocation: this.widget.location,
          postImage: this.widget.image,
          postImageUrl: this.widget.imageUrl,
          postDescription: this.widget.description,
        );
        setState(() {
          this._isLoading = false;
        });
        this._showDialog("Congratulations", "You have successfully posted!");
        this._form.currentState.reset();
      } catch (error) {
        final errorMessage = "Error while submitting the post! Please try again later...";
        setState(() {
          this._isLoading = false;
        });
        this._showDialog("An error occured", errorMessage, success: false);
        throw error;
      }
    }
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
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  this._type = 'video';
                  this._setMedia();
                });
              },
              child: Text(
                'Capture video',
                style: TextStyle(color: Colors.blue),
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
                    this.widget.imageUrl = this._imageUrlController.text;
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
      case 'video':
        return;
      default:
        return;
    }

    setState(() {
      this.widget.image = File(imageFile.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    setState(() {
      this.widget.imageUrl = savedImage.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: this._form,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: this._mediaType,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.black45,
                        ],
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                      ),
                    ),
                    child: this.widget.image == null &&
                            (this.widget.imageUrl == null || this.widget.imageUrl.isEmpty)
                        ? Center(
                            child: Icon(
                              Icons.add,
                              size: 100,
                              color: Colors.white,
                            ),
                          )
                        : this.widget.image != null
                            ? Image.file(
                                this.widget.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.network(
                                this.widget.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  key: ValueKey('location'),
                  initialValue: this.widget.location,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: .5, color: Colors.black)),
                  ),
                  validator: (value) {
                    return locationValidator(value);
                  },
                  onSaved: (newValue) {
                    this.widget.location = newValue;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  key: ValueKey('description'),
                  initialValue: this.widget.description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: .5, color: Colors.black)),
                  ),
                  validator: (value) => descriptionValidator(value),
                  onSaved: (newValue) {
                    this.widget.description = newValue;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                child: RaisedButton(
                  onPressed: this._submitForm,
                  child: this._isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          this.widget.isUpdating ? 'Update' : 'Post',
                          style: TextStyle(color: Colors.white),
                        ),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
