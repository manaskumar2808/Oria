import 'package:flutter/material.dart';

import './login_screen.dart';
import './signup_screen.dart';

class GuestScreen extends StatelessWidget {
  static const String routeName = '/guest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/guest-image-dark.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Positioned(
              top: 100,
              left: 30,
              child: Container(
                width: 270,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Explore it!',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 34, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Time for you to visit the world with the help of oria and make life exciting to a great level, this will make you adventurous for sure.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(207, 212, 212, 1)),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                width: 370,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignupScreen.routeName);
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                                color: Color.fromRGBO(207, 212, 212, 1)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            },
                            child: Text(
                              ' Log in',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
