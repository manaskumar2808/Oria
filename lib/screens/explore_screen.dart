import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oria/widgets/place_form.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/destination_list.dart';
import '../widgets/circular_profile_item.dart';

import '../screens/place_form_screen.dart';

import '../providers/user_provider.dart';

import 'app_drawer_screen.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentStaticUser;

    return Scaffold(
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: CircularProfileItem(
                        imageUrl: currentUser.profileImageUrl,
                        haveBorder: false,
                        profileRadius: 40,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 6,
                      child: Text(
                        currentUser.userName.isEmpty
                            ? ' Hello Friend'
                            : ' Hello ${currentUser.userName}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'What you would like to find?',
                    style: TextStyle(fontSize: 37, fontWeight: FontWeight.bold),
                  )),
              DestinationList(destinationType: 'expensive'),
              DestinationList(destinationType: 'adventurous'),
              DestinationList(destinationType: 'easy'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(PlaceFormScreen.routeName);
        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
