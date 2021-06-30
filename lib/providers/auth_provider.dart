import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/error_handlers/http_error_handler.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiry;
  String _userId;

  bool newUser = true;

  Future<void> _authUser(
      String email, String password, String authString) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$authString?key=AIzaSyCjKOhiX0M99mHEl9y9UbbWF5x-HsXq68E';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData.containsKey('error')) {
        throw HttpErrorHandler(message: responseData['error']['message']);
      }

      this._token = responseData['idToken'];
      this._expiry = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      this._userId = responseData['localId'];
      notifyListeners();

      var prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': this._token,
        'expiryDate': this._expiry.toIso8601String(),
        'userId': this._userId,
      });
      prefs.setString('userData', userData);
      prefs.setBool('newUser', true);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password, String userName) async {
    return this._authUser(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return this._authUser(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    this._token = extractedUserData['token'];
    this._expiry = expiryDate;
    this._userId = extractedUserData['userId'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    this._token = null;
    this._expiry = null;
    this._userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.setBool('newUser', false);
  }

  Future<void> get isNewUser async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('newUser')) {
      this.newUser = prefs.getBool('newUser');
    }
    this.newUser = true;
  }

  String get token {
    if (this._expiry != null &&
        this._expiry.isAfter(DateTime.now()) &&
        this._token != null) {
      return this._token;
    }
    return null;
  }

  String get userId {
    return this._userId;
  }

  bool get isAuth {
    return this._token != null;
  }
}
