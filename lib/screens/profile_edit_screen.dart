import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_edit_form.dart';
import '../widgets/circular_loader.dart';

import '../providers/user_provider.dart';

class ProfileEditScreen extends StatelessWidget {
  static const String routeName = '/profile-edit';

  bool _isLoading = false;

  void _showDialog(BuildContext context, String title, String message,
      {bool success = true}) {
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
              'OK',
              style: TextStyle(color: success ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _profileSubmitFn(
    String id, {
    BuildContext context,
    String userName,
    String email,
    String firstName,
    String lastName,
    String profileImageUrl,
    String phoneNo,
  }) async {
    this._isLoading = true;
    try {
      await Provider.of<UserProvider>(context, listen: false).updateUser(
        id,
        userName: userName,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNo: phoneNo,
        profileImageUrl: profileImageUrl,
      );
      this._showDialog(context, "Profile Updated",
          "Your profile has been successfully updated.");
      this._isLoading = false;
    } on PlatformException catch (error) {
      var errorMessage =
          "Can't update details at the moment! Please try again later...";
      this._isLoading = false;
      if (error.message.isNotEmpty) {
        errorMessage = error.message;
      }
      this._showDialog(context, "An error occured", errorMessage);
    } catch (error) {
      print(firstName);
      final errorMessage =
          "Error while submitting the post! Please try again later...";
      this._showDialog(context, "An error occured", errorMessage,
          success: false);
      this._isLoading = false;
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Edit Profile'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.check,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: Provider.of<UserProvider>(context).currentUser,
          builder: (context, currentUserSnapshot) =>
              currentUserSnapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularLoader(
                        thickness: 1,
                      ),
                    )
                  : ProfileEditForm(
                      this._isLoading,
                      userId: currentUserSnapshot.data.userId,
                      userName: currentUserSnapshot.data.userName,
                      email: currentUserSnapshot.data.email,
                      firstName: currentUserSnapshot.data.firstName,
                      lastName: currentUserSnapshot.data.lastName,
                      profileImage: currentUserSnapshot.data.profileImage,
                      profileImageUrl: currentUserSnapshot.data.profileImageUrl,
                      phoneNo: currentUserSnapshot.data.phoneNo,
                      profileSubmit: this._profileSubmitFn,
                    ),
        ),
      ),
    );
  }
}
