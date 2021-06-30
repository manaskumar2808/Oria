import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/signup_form.dart';
import '../widgets/back_button.dart' as back_button;

import '../providers/user_provider.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void _showErrorDialogue(String errorMessage, BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('An error occured!'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _submitForm({
    String email,
    String password,
    String userName,
    BuildContext ctx,
  }) async {
    try {
      setState(() {
        this.isLoading = true;
      });

      AuthResult authResult;
      authResult = await this._auth.createUserWithEmailAndPassword(email: email, password: password);
      await Provider.of<UserProvider>(context,listen: false).addUser(authResult, userName: userName, email: email);

      setState(() {
        this.isLoading = false;
      });

      Navigator.of(context).pop();

      // await Provider.of<UserProvider>(context, listen: false).addUser(
      //   userName: this._userName,
      //   email: this._email,
      // );
    } on PlatformException catch (error) {
      setState(() {
        this.isLoading = false;
      });

      var errorMessage = "Authentication failed!";
      if (error.message.isNotEmpty) {
        errorMessage = error.message;
      }
      // if (error.toString().contains('EMAIL_EXISTS')) {
      //   errorMessage = "This email address is already taken!";
      // } else if (error.toString().contains('INVALID_EMAIL')) {
      //   errorMessage = "This email address is invalid.";
      // } else if (error.toString().contains('WEAK_PASSWORD')) {
      //   errorMessage = "Please provide a strong password.";
      // } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
      //   errorMessage = "Email not found!";
      // } else if (error.toString().contains('INVALID_PASSWORD')) {
      //   errorMessage = "Provided password is invalid.";
      // }
      this._showErrorDialogue(errorMessage, ctx);
    } catch (error) {
      setState(() {
        this.isLoading = false;
      });

      var errorMessage = "Couldn't authenticate at the moment, Please try after some time!";
      this._showErrorDialogue(errorMessage, ctx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: back_button.BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(20),
          child: SignupForm(this._submitForm, this.isLoading),
        ),
      ),
    );
  }
}
