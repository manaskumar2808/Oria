import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    BuildContext ctx,
  }) async {
    try {
      setState(() {
        this.isLoading = true;
      });
      
      AuthResult authResult;
      authResult = await this
          ._auth
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        this.isLoading = false;
      });
    } on PlatformException catch (error) {
      setState(() {
        this.isLoading = false;
      });

      var errorMessage = "Login error!";
      if (error.message.isNotEmpty) {
        errorMessage = error.message;
      }

      // if (error.toString().contains('EMAIL_NOT_FOUND')) {
      //   errorMessage = "This email is not found!";
      // } else if (error.toString().contains('INVALID_PASSWORD')) {
      //   errorMessage = "Entered password is invalid!";
      // }
      this._showErrorDialogue(errorMessage, ctx);
    } catch (error) {
      setState(() {
        this.isLoading = false;
      });
      
      var errorMessage =
          "Couldn't login at the moment, Please try after some time...";
      this._showErrorDialogue(errorMessage, ctx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/guest-image-dark.jpg',
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity,
            ),
            Positioned(
              top: 70,
              left: 30,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome To...',
                    style: TextStyle(color: Colors.white, fontSize: 34),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Good to see you at oria, hope you will enjoy its features and luxuries.',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromRGBO(207, 212, 212, 1)),
                  ),
                ],
              ),
            ),
            LoginForm(this._submitForm, this.isLoading),
          ],
        ),
      ),
    );
  }
}
