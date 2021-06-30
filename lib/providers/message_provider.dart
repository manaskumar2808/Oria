import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/message.dart';

class MessageProvider with ChangeNotifier {
  List<Message> _messages = [];

  Future<List<Message>> get messages async {
    return [...this._messages];
  }

  Stream<List<Message>> contactMessagesStream(String contactId) async* {
    this.fetchAndSetContactMessageStream(contactId);
    yield [...this._messages];
  }

  Future<List<Message>> contactMessages(String contactId) async {
    await this.fetchAndSetContactMessages(contactId);
    return [...this._messages];
  }

  Future<void> fetchAndSetContactMessages(String contactId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final messages = await Firestore.instance
        .collection('chats')
        .document(userId)
        .collection('contacts')
        .document(contactId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .getDocuments();

    List<Message> loadedMessages = [];

    messages.documents.forEach((document) {
      final message = document.data;
      loadedMessages.add(Message(
        messageId: document.documentID,
        text: message['text'],
        senderId: message['senderId'],
        receiverId: message['receiverId'],
        contactId: message['contactId'],
        messageImageUrl: message['messageImageUrl'],
        messageStatus: message['messageStatus'],
        isFeed: message['isFeed'],
        feedId: message['feedId'],
        feedCreatorUserId: message['feedCreatorUserId'],
        feedCreatorUserName: message['feedCreatorUserName'],
        feedCreatorImageUrl: message['feedCreatorImageUrl'],
        timestamp: DateTime.parse(message['timestamp']),
      ));
    });

    this._messages = loadedMessages;
  }

  Stream<void> fetchAndSetContactMessageStream(String contactId) async* {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final messages = Firestore.instance
        .collection('chats')
        .document(userId)
        .collection('contacts')
        .document(contactId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();

    List<Message> loadedMessages = [];

    print(messages);

    messages.listen((event) {
      event.documents.forEach((document) {
        final message = document.data;
        print(message);
        loadedMessages.add(Message(
            messageId: document.documentID,
            text: message['text'],
            senderId: message['senderId'],
            receiverId: message['receiverId'],
            contactId: message['contactId'],
            messageImageUrl: message['messageImageUrl'],
            isFeed: message['isFeed'],
            feedId: message['feedId'],
            feedCreatorUserId: message['feedCreatorUserId'],
            feedCreatorUserName: message['feedCreatorUserName'],
            feedCreatorImageUrl: message['feedCreatorImageUrl'],
            messageStatus: message['messageStatus'],
            timestamp: DateTime.parse(message['timestamp'])));
      });
      print(loadedMessages);
      this._messages = loadedMessages;
    });
  }

  Future<void> addMessage({
    String text,
    File messageImage,
    String messageImageUrl,
    String receiverId,
    String contactId,
    bool isFeed = false,
    String feedId,
    String feedCreatorUserId,
    String feedCreatorUserName,
    String feedCreatorImageUrl,
  }) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    if (receiverId != userId) {
      final messageRef = Firestore.instance
          .collection('chats')
          .document(userId)
          .collection('contacts')
          .document(contactId)
          .collection('messages')
          .document();

      final messageId = messageRef.documentID;

      if (messageImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('message_image')
            .child(messageId + '.jpg');
        await ref.putFile(messageImage).onComplete;
        messageImageUrl = await ref.getDownloadURL();
      }

      await messageRef.setData({
        'text': text,
        'messageImageUrl': messageImageUrl,
        'senderId': userId,
        'receiverId': receiverId,
        'isFeed': isFeed,
        'feedId': feedId,
        'feedCreatorUserId': feedCreatorUserId,
        'feedCreatorUserName': feedCreatorUserName,
        'feedCreatorImageUrl': feedCreatorImageUrl,
        'timestamp': DateTime.now().toIso8601String(),
        'messageStatus': 'sent',
      });

      this._messages.add(Message(
            messageId: messageId,
            text: text,
            senderId: userId,
            receiverId: receiverId,
            contactId: contactId,
            messageImageUrl: messageImageUrl,
            isFeed: isFeed,
            feedId: feedId,
            feedCreatorUserId: feedCreatorUserId,
            feedCreatorUserName: feedCreatorUserName,
            feedCreatorImageUrl: feedCreatorImageUrl,
            timestamp: DateTime.now(),
            messageStatus: 'sent',
          ));

      await Firestore.instance
          .collection('chats')
          .document(receiverId)
          .collection('contacts')
          .document(userId)
          .collection('messages')
          .document()
          .setData({
        'text': text,
        'messageImageUrl': messageImageUrl,
        'senderId': userId,
        'receiverId': receiverId,
        'isFeed': isFeed,
        'feedId': feedId,
        'feedCreatorUserId': feedCreatorUserId,
        'feedCreatorUserName': feedCreatorUserName,
        'feedCreatorImageUrl': feedCreatorImageUrl,
        'timestamp': DateTime.now().toIso8601String(),
        'messageStatus': 'received',
      });

      notifyListeners();
    }
  }

  Future<void> removeMessage(
      {String contactId,
      String receiverId,
      String messageId,
      bool removeByFeedId = false,
      String feedId}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    if (removeByFeedId) {
      final message = await Firestore.instance
          .collection('chats')
          .document(userId)
          .collection('contacts')
          .document(contactId)
          .collection('messages')
          .where('feedId', isEqualTo: feedId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .getDocuments();
      message.documents
          .removeWhere((document) => document.data['feedId'] == feedId);

      final receiverMessage = await Firestore.instance
          .collection('chats')
          .document(contactId)
          .collection('contacts')
          .document(userId)
          .collection('messages')
          .where('feedId', isEqualTo: feedId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .getDocuments();
      receiverMessage.documents
          .removeWhere((document) => document.data['feedId'] == feedId);
      notifyListeners();
    } else {
      await Firestore.instance
          .collection('chats')
          .document(userId)
          .collection('contacts')
          .document(contactId)
          .collection('messages')
          .document(messageId)
          .delete();

      this._messages.removeWhere((message) => message.messageId == messageId);

      await Firestore.instance
          .collection('chats')
          .document(receiverId)
          .collection('contacts')
          .document(userId)
          .collection('messages')
          .document(messageId)
          .delete();

      notifyListeners();
    }
  }
}
