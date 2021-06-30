import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oria/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

import '../providers/story_provider.dart';

import '../validators/story_validators.dart';

import './circular_loader.dart';

class StoryForm extends StatefulWidget {
  @override
  _StoryFormState createState() => _StoryFormState();
}

class _StoryFormState extends State<StoryForm> {
  final _form = GlobalKey<FormState>();

  String _type = '';
  var _imageUrlController = TextEditingController();

  // fields
  File image;
  String imageUrl = '';
  String statusTitle;
  String statusCaption;

  bool isLoading = false;

  @override
  void dispose() {
    this._imageUrlController.dispose();
    this._form.currentState.dispose();
    super.dispose();
  }

  void _submitStory() async {
    setState(() {
      this.isLoading = true;
    });
    final isValid = this._form.currentState.validate();
    if (!isValid) {
      setState(() {
        this.isLoading = false;
      });
      return;
    }

    if (this.image == null || this.imageUrl.isEmpty) {
      setState(() {
        this.isLoading = false;
      });
      return;
    }

    this._form.currentState.save();

    final currentUser = await Provider.of<UserProvider>(context, listen: false).currentUser;

    try {
      await Provider.of<StoryProvider>(context, listen: false).addStory(
        storyTitle: this.statusTitle,
        storyCaption: this.statusCaption,
        storyImageUrl: this.imageUrl,
        storyTellerUserId: currentUser.userId,
        storyTellerUserName: currentUser.userName,
        storyTellerProfileImage: currentUser.profileImageUrl,
      );
      this.isLoading = false;
    } catch (error) {
      this.isLoading = false;
      throw error;
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

  void _showStoryForm({BuildContext context}) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Form(
              key: this._form,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('title'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Status Title',
                    ),
                    validator: (value) => storyTitleValidator(value),
                    onSaved: (newValue) {
                      this.statusTitle = newValue;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: ValueKey('description'),
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Status Caption',
                    ),
                    validator: (value) => storyCaptionValidator(value),
                    onSaved: (newValue) {
                      this.statusCaption = newValue;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: .5,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.blue,
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
          colors: [
            Colors.white,
            Colors.black54,
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.clear),
                  iconSize: 30,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Expanded(
              child: this.image == null && this.imageUrl.isEmpty
                  ? IconButton(
                      onPressed: this._mediaType,
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 60,
                      color: Colors.white,
                    )
                  : this.image != null
                      ? Image.file(
                          this.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Image.network(
                          this.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: IconButton(
                    onPressed: this._mediaType,
                    icon: Icon(Icons.camera_alt),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: OutlineButton(
                    onPressed: this._submitStory,
                    borderSide: BorderSide(color: Colors.white, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: this.isLoading
                        ? CircularLoader(
                            color: Colors.white,
                            diameter: 20,
                          )
                        : Text('Add Status'),
                    color: Colors.white,
                    textColor: Colors.white,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: IconButton(
                    onPressed: () => this._showStoryForm(context: context),
                    icon: Icon(Icons.add_box),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
