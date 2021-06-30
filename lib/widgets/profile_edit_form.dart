import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/circular_profile_item.dart';

import '../validators/user_validators.dart';

class ProfileEditForm extends StatefulWidget {
  String userId;
  String userName = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  File profileImage;
  String profileImageUrl = '';
  String phoneNo = '';

  final Future<void> Function(
    String id, {
    BuildContext context,
    String userName,
    String email,
    String firstName,
    String lastName,
    String profileImageUrl,
    String phoneNo,
  }) profileSubmit;

  bool _isLoading = false;

  ProfileEditForm(
    this._isLoading, {
    this.userId,
    this.userName,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.profileImageUrl,
    this.phoneNo,
    this.profileSubmit,
  });

  @override
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  var _form = GlobalKey<FormState>();

  var _imageUrlController = TextEditingController();

  String _type = '';

  @override
  void dispose() {
    this._imageUrlController.dispose();
    super.dispose();
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
                    this.widget.profileImageUrl = this._imageUrlController.text;
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
          maxWidth: 200,
        );
        break;
      case 'gallery':
        imageFile = await picker.getImage(
          source: ImageSource.gallery,
          maxWidth: 200,
        );
        break;
      default:
        return;
    }

    setState(() {
      this.widget.profileImage = File(imageFile.path);
    });

    // final appDir = await syspath.getApplicationDocumentsDirectory();
    // final fileName = path.basename(imageFile.path);
    // final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');

    // this.widget.profileImageUrl = savedImage.path;

    final ref = FirebaseStorage.instance.ref().child('profile_image').child(this.widget.userId + '.jpg');
    await ref.putFile(this.widget.profileImage).onComplete;
    final imageUrl = await ref.getDownloadURL();

    setState(() {
      this.widget.profileImageUrl = imageUrl;
    });
    
  }

  void _submitForm(String id) async {
    final isValid = this._form.currentState.validate();
    if (!isValid) {
      return;
    }
    this._form.currentState.save();

    await this.widget.profileSubmit(
          id,
          context: context,
          userName: this.widget.userName,
          email: this.widget.email,
          firstName: this.widget.firstName,
          lastName: this.widget.lastName,
          profileImageUrl: this.widget.profileImageUrl,
          phoneNo: this.widget.phoneNo,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Form(
        key: this._form,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: this._mediaType,
                child: CircularProfileItem(
                  imageUrl: this.widget.profileImageUrl,
                  profileRadius: 60,
                  haveBorder: false,
                ),
              ),
              FlatButton(
                onPressed: this._mediaType,
                child: Text(
                  'change profile picture',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextFormField(
                key: ValueKey('userName'),
                initialValue: this.widget.userName,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => userNameValidator(value),
                onSaved: (newValue) {
                  this.widget.userName = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                key: ValueKey('email'),
                initialValue: this.widget.email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => emailValidator(value),
                onSaved: (newValue) {
                  this.widget.email = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                key: ValueKey('firstName'),
                initialValue: this.widget.firstName,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => firstNameValidator(value),
                onSaved: (newValue) {
                  this.widget.firstName = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                key: ValueKey('lastName'),
                initialValue: this.widget.lastName,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => lastNameValidator(value),
                onSaved: (newValue) {
                  this.widget.lastName = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                key: ValueKey('phoneNo'),
                initialValue: this.widget.phoneNo,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => phoneNoValidator(value),
                onSaved: (newValue) {
                  this.widget.phoneNo = newValue;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () => this._submitForm(this.widget.userId),
                  child: Text(
                    this.widget._isLoading
                        ? CircularProgressIndicator()
                        : 'Edit',
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
    );
  }
}
