import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              'Notifications',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              'Privacy',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              'About',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              'Help',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              'Settings',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          FlatButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // Navigator.of(context).pop();
              // Provider.of<AuthProvider>(context,listen: false).logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
