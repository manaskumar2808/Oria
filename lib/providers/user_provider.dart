import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  // String authToken;
  // String userId;

  User _currentUser;

  List<User> _users = [];

  //getting users list
  Future<List<User>> get users async {
    await this.fetchAndSetUsers();
    return [...this._users];
  }

  Future<List<User>> get otherUsers async {
    await this.fetchAndSetUsers(removeMe: true);
    return [...this._users];
  }

  Future<User> get currentUser async {
    await this.fetchAndSetUsers();
    await this.setCurrentUser();
    return this._currentUser;
  }

  User get currentStaticUser {
    return this._currentUser;
  }

  Future<User> findById(String id) async {
    return this._users.firstWhere((user) => user.userId == id);
  }

  Future<void> setCurrentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userId = user.uid;
    this._currentUser = await this.findById(userId);
  }

  Future<void> fetchAndSetUsers({bool removeMe = false}) async {
    // final url =
    //     'https://oria-12369.firebaseio.com/users.json?auth=${this.authToken}';
    // final response = await http.get(url);
    // final responseData = json.decode(response.body) as Map<String, dynamic>;
    // List<User> loadedUsers = [];
    // responseData.forEach((id, user) {
    //   loadedUsers.add(User(
    //     authUserId: user['authUserId'],
    //     userId: id,
    //     userName: user['userName'],
    //     email: user['email'],
    //     firstName: user['firstName'],
    //     lastName: user['lastName'],
    //     profileImage: user['profileImage'],
    //     profileImageUrl: user['profileImageUrl'],
    //     phoneNo: user['phoneNo'],
    //   ));
    // });
    final user = await FirebaseAuth.instance.currentUser();
    final userId = user.uid;

    final users = await Firestore.instance.collection('users').getDocuments();

    List<User> loadedUsers = [];

    users.documents.forEach((document) {
      final user = document.data;
      if(removeMe){
        if(document.documentID != userId){
          loadedUsers.add(User(
            userId: document.documentID,
            userName: user['userName'],
            email: user['email'],
            firstName: user['firstName'],
            lastName: user['lastName'],
            profileImage: user['profileImage'],
            profileImageUrl: user['profileImageUrl'],
            phoneNo: user['phoneNo'],
        ));
        }
      } else {
        loadedUsers.add(User(
            userId: document.documentID,
            userName: user['userName'],
            email: user['email'],
            firstName: user['firstName'],
            lastName: user['lastName'],
            profileImage: user['profileImage'],
            profileImageUrl: user['profileImageUrl'],
            phoneNo: user['phoneNo'],
        ));
      }


    });

    this._users = loadedUsers;
  }

  Future<void> addUser(AuthResult authResult,
      {String userName,
      String email,
      String firstName = '',
      String lastName = '',
      String profileImageUrl = '',
      String phoneNo = '',
      File profileImage}) async {
    await Firestore.instance
        .collection('users')
        .document(authResult.user.uid)
        .setData({
      'userName': userName,
      'email': email,
    });

    final userId = authResult.user.uid;
    // final url =
    //     'https://oria-12369.firebaseio.com/users.json?auth=${this.authToken}';
    // final response = await http.post(url,
    //     body: json.encode({
    //       'authUserId': this.userId,
    //       'userName': userName,
    //       'email': email,
    //       'firstName': firstName,
    //       'lastName': lastName,
    //       'phoneNo': phoneNo,
    //       'profileImageUrl': profileImageUrl,
    //       'profileImage': profileImage,
    //     }));
    // this.fetchAndSetUsers();
    final user = User(
      userId: userId,
      userName: userName,
      email: email,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
      profileImageUrl: profileImageUrl,
      phoneNo: phoneNo,
    );
    this._users.add(user);
    notifyListeners();
  }

  Future<void> updateUser(String id,
      {String userName = '',
      String email = '',
      String firstName = '',
      String lastName = '',
      String profileImageUrl = '',
      String phoneNo = '',
      File profileImage}) async {
    // final url =
    //     'https://oria-12369.firebaseio.com/users/$id.json?auth=${this.authToken}';

    // var oldUser = this.findByAuthId(id);

    // final response = await http.patch(url,
    //     body: json.encode({
    //       'userId': id,
    //       'authUserId': this.userId,
    //       'userName': userName == '' ? oldUser.userName : userName,
    //       'email': email == '' ? oldUser.email : email,
    //       'firstName': firstName == '' ? oldUser.firstName : firstName,
    //       'lastName': lastName == '' ? oldUser.lastName : lastName,
    //       'profileImageUrl':
    //           profileImageUrl == '' ? oldUser.profileImageUrl : profileImageUrl,
    //       'profileImage':
    //           profileImage == null ? oldUser.profileImage : profileImage,
    //       'phoneNo': phoneNo == null ? oldUser.phoneNo : phoneNo,
    //     }));

    final userIndex = this._users.indexWhere((user) => user.userId == id);
    final oldUser = this._users[userIndex];
    this._users[userIndex].userName =
        userName == null || userName.isEmpty ? oldUser.userName : userName;
    this._users[userIndex].email =
        email == null || email.isEmpty ? oldUser.email : email;
    this._users[userIndex].firstName =
        firstName == null || firstName.isEmpty ? oldUser.firstName : firstName;
    this._users[userIndex].lastName =
        lastName == null || lastName.isEmpty ? oldUser.lastName : lastName;
    this._users[userIndex].profileImage =
        profileImage == null ? oldUser.profileImage : profileImage;
    this._users[userIndex].profileImageUrl =
        profileImageUrl == null || profileImageUrl.isEmpty
            ? oldUser.profileImageUrl
            : profileImageUrl;
    this._users[userIndex].phoneNo =
        phoneNo == null || phoneNo.isEmpty ? oldUser.phoneNo : phoneNo;

    await Firestore.instance
        .collection('users')
        .document(id.trim())
        .updateData({
      'userName':
          userName == null || userName.isEmpty ? oldUser.userName : userName,
      'email': email == null || email.isEmpty ? oldUser.email : email,
      'firstName': firstName == null || firstName.isEmpty
          ? oldUser.firstName
          : firstName,
      'lastName':
          lastName == null || lastName.isEmpty ? oldUser.lastName : lastName,
      'profileImageUrl': profileImageUrl == null || profileImageUrl.isEmpty
          ? oldUser.profileImageUrl
          : profileImageUrl,
      'profileImage':
          profileImage == null ? oldUser.profileImage : profileImage,
      'phoneNo': phoneNo == null || phoneNo.isEmpty ? oldUser.phoneNo : phoneNo,
    });

    notifyListeners();
  }

  Future<void> removeUser(String id) async {
    // final url =
    //     'https://oria-12369.firebaseio.com/users/$id.json?auth=${this.authToken}';
    // final response = await http.delete(url);
    // var existingUserIndex =
    //     this._users.indexWhere((user) => user.authUserId == id);
    // var existingUser = this._users[existingUserIndex];
    // this._users.removeWhere((user) => user.authUserId == id);
    await Firestore.instance.collection('users').document(id).delete();
    this._users.removeWhere((user) => user.userId == id);
    notifyListeners();
  }
}
