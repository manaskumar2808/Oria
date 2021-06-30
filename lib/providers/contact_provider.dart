import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';
import '../models/user.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts;

  Future<List<Contact>> get contacts async {
    await this.fetchAndSetContacts();
    return [...this._contacts];
  }

  Future<List<User>> get notContacts async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final currentUserId = currentUser.uid;

    final users = await Firestore.instance.collection('users').getDocuments();
    await this.fetchAndSetContacts();
    List<User> notContacts = [];
    users.documents.forEach((document) {
      final user = document.data;
      final index = this
          ._contacts
          .indexWhere((contact) => contact.contactId == document.documentID);
      if (index == -1) {
        if(currentUserId != document.documentID){
           notContacts.add(User(
              userId: document.documentID,
              userName: user['userName'],
              email: user['email'],
              profileImageUrl: user['profileImageUrl'],
              firstName: user['firstName'],
              lastName: user['lastName'],
              phoneNo: user['phoneNo'],
            ));
        }
      }
    });

    return notContacts;
  }

  Future<void> fetchAndSetContacts() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final contacts = await Firestore.instance
        .collection('chats')
        .document(userId)
        .collection('contacts')
        .getDocuments();

    List<Contact> loadedContacts = [];
    contacts.documents.forEach((document) {
      if (document.documentID != userId) {
        final contact = document.data;
        loadedContacts.add(Contact(
          contactId: document.documentID,
          name: contact['name'],
          imageUrl: contact['imageUrl'],
          createdTimestamp: DateTime.parse(contact['createdTimestamp']),
        ));
      }
    });

    this._contacts = loadedContacts;
  }

  Future<void> addSenderContact({
    String senderName,
    String senderImageUrl,
    String senderUserId,
  }) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    await Firestore.instance
        .collection('chats')
        .document(senderUserId)
        .collection('contacts')
        .document(userId)
        .setData({
      'name': senderName,
      'imageUrl': senderImageUrl,
      'createdTimestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> addContact({
    String name,
    String imageUrl,
    String contactUserId,
  }) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    if (contactUserId != userId) {
      await Firestore.instance
          .collection('chats')
          .document(userId)
          .collection('contacts')
          .document(contactUserId)
          .setData({
        'name': name,
        'imageUrl': imageUrl,
        'createdTimestamp': DateTime.now().toIso8601String(),
      });

      this._contacts.add(Contact(
            contactId: contactUserId,
            name: name,
            imageUrl: imageUrl,
            createdTimestamp: DateTime.now(),
          ));

      notifyListeners();
    }
  }

  Future<void> removeContact({String contactId}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    await Firestore.instance
        .collection('chats')
        .document(userId)
        .collection('contacts')
        .document(contactId)
        .delete();

    this._contacts.removeWhere((contact) => contact.contactId == contactId);

    notifyListeners();
  }
}
