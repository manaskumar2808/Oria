import 'dart:io';

import 'package:flutter/foundation.dart';

class User {
  String userId;
  String userName;
  String email;
  String firstName;
  String lastName;
  String profileImageUrl;
  File profileImage;
  String phoneNo;

  User({
    @required this.userId,
    @required this.userName,
    @required this.email,
    this.firstName,
    this.lastName,
    this.phoneNo,
    this.profileImageUrl,
    this.profileImage,
  });
}
