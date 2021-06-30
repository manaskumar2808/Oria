import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'Oria',
            style: TextStyle(
              color: Color.fromRGBO(5, 5, 5, 1),
              fontFamily: 'BillionDreams_PERSONAL',
              fontWeight: FontWeight.bold,
              fontSize: 45,
            ),
          ),
        ),
      ),
    );
  }
}