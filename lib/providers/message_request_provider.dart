import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message_request.dart';

class MessageRequestProvider with ChangeNotifier {
  List<MessageRequest> _receivedMessageRequests = [];
  List<MessageRequest> _deliveredMessageRequests = [];

  Future<List<MessageRequest>> get receivedMessageRequests async {
    await this.fetchAndSetReceivedMessageRequests();
    return [...this._receivedMessageRequests];
  }

  Future<List<MessageRequest>> get deliveredMessageRequests async {
    await this.fetchAndSetDeliveredMessageRequests();
    return [...this._deliveredMessageRequests];
  }

  Future<void> fetchAndSetDeliveredMessageRequests() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final deliveredMessageRequests = await Firestore.instance
        .collection('message-requests')
        .document(userId)
        .collection('delivered')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<MessageRequest> loadedMessageRequests = [];
    deliveredMessageRequests.documents.forEach((document) {
      final deliveredMessageRequest = document.data;
      loadedMessageRequests.add(MessageRequest(
        senderId: deliveredMessageRequest['senderId'],
        receiverId: deliveredMessageRequest['receiverId'],
        requestCaption: deliveredMessageRequest['requestCaption'],
        timestamp: DateTime.parse(deliveredMessageRequest['timestamp']),
        requestStatus: deliveredMessageRequest['requestStatus'],
      ));
    });

    this._deliveredMessageRequests = loadedMessageRequests;
  }

  Future<void> fetchAndSetReceivedMessageRequests() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final receivedMessageRequests = await Firestore.instance
        .collection('message-requests')
        .document(userId)
        .collection('received')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<MessageRequest> loadedMessageRequests = [];
    receivedMessageRequests.documents.forEach((document) {
      final receivedMessageRequest = document.data;
      loadedMessageRequests.add(MessageRequest(
        senderId: receivedMessageRequest['senderId'],
        receiverId: receivedMessageRequest['receiverId'],
        requestCaption: receivedMessageRequest['requestCaption'],
        timestamp: DateTime.parse(receivedMessageRequest['timestamp']),
        requestStatus: receivedMessageRequest['requestStatus'],
      ));
    });

    this._receivedMessageRequests = loadedMessageRequests;
  }

  Future<bool> isRequested(String receiverId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final request = await Firestore.instance
        .collection('message-requests')
        .document(userId)
        .collection('delivered')
        .document(receiverId)
        .get();
    final isRequested = request.data == null ? false : true;
    return isRequested;
  }

  Future<void> addMessageRequest({
    String receiverId,
    String requestCaption,
  }) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final isRequested = await this.isRequested(receiverId);

    if (!isRequested) {
      await Firestore.instance
          .collection('message-requests')
          .document(userId)
          .collection('delivered')
          .document(receiverId)
          .setData({
        'senderId': userId,
        'receiverId': receiverId,
        'requestCaption': requestCaption,
        'timestamp': DateTime.now().toIso8601String(),
        'requestStatus': 'sent',
      });

      this._deliveredMessageRequests.add(MessageRequest(
            senderId: userId,
            receiverId: receiverId,
            requestCaption: requestCaption,
            timestamp: DateTime.now(),
            requestStatus: 'sent',
          ));

      await Firestore.instance
          .collection('message-requests')
          .document(receiverId)
          .collection('received')
          .document(userId)
          .setData({
        'senderId': userId,
        'receiverId': receiverId,
        'requestCaption': requestCaption,
        'timestamp': DateTime.now().toIso8601String(),
        'requestStatus': 'received',
      });

      notifyListeners();
    } else {
      await this.removeMessageRequest(receiverId: receiverId);
    }
  }

  Future<void> updateMessageRequest(
      {@required String receiverId, @required String requestCaption}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    await Firestore.instance
        .collection('message-requests')
        .document(userId)
        .collection('delivered')
        .document(receiverId)
        .updateData({
      'requestCaption': requestCaption,
    });

    final messageRequestIndex = this._deliveredMessageRequests.indexWhere(
        (messageRequest) => messageRequest.receiverId == receiverId);
    this._deliveredMessageRequests[messageRequestIndex].requestCaption =
        requestCaption;

    await Firestore.instance
        .collection('message-requests')
        .document(receiverId)
        .collection('received')
        .document(userId)
        .updateData({
      'requestCaption': requestCaption,
    });

    notifyListeners();
  }

  Future<void> removeMessageRequest({String receiverId}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    await Firestore.instance
        .collection('message-requests')
        .document(userId)
        .collection('delivered')
        .document(receiverId)
        .delete();

    this._deliveredMessageRequests.removeWhere(
        (messageRequest) => messageRequest.receiverId == receiverId);

    await Firestore.instance
        .collection('message-requests')
        .document(receiverId)
        .collection('received')
        .document(userId)
        .delete();

    notifyListeners();
  }

  Future<void> acceptMessageRequest({String senderId}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    await Firestore.instance
        .collection('message-requests')
        .document(userId)
        .collection('received')
        .document(senderId)
        .delete();

    this
        ._receivedMessageRequests
        .removeWhere((messageRequest) => messageRequest.senderId == senderId);

    await Firestore.instance
        .collection('message-requests')
        .document(senderId)
        .collection('delivered')
        .document(userId)
        .updateData({
      'requestStatus': 'accepted',
    });

    notifyListeners();
  }

  Future<void> declineMessageRequest({String senderId}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    await Firestore.instance
        .collection('message-requests')
        .document(userId)
        .collection('received')
        .document(senderId)
        .delete();

    this
        ._receivedMessageRequests
        .removeWhere((messageRequest) => messageRequest.senderId == senderId);

    await Firestore.instance
        .collection('message-requests')
        .document(senderId)
        .collection('delivered')
        .document(userId)
        .updateData({
      'requestStatus': 'rejected',
    });

    notifyListeners();
  }
}
