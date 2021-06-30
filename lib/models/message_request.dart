import 'package:flutter/foundation.dart';

class MessageRequest {
  String senderId;
  String receiverId;
  String requestCaption;
  DateTime timestamp;
  String requestStatus;

  MessageRequest({
    @required this.senderId,
    @required this.receiverId,
    this.requestCaption,
    @required this.timestamp,
    @required this.requestStatus,
  });
}
