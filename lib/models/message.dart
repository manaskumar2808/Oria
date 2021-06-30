import 'package:flutter/foundation.dart';

class Message {
  final String messageId;
  final String text;
  final String senderId;
  final String receiverId;
  final String messageImageUrl;
  final DateTime timestamp;
  String messageStatus;
  final String contactId;
  final bool isFeed;
  final String feedId;
  final String feedCreatorUserId;
  final String feedCreatorUserName;
  final String feedCreatorImageUrl;

  Message({
    @required this.messageId,
    this.text,
    @required this.senderId,
    @required this.receiverId,
    this.messageImageUrl,
    @required this.timestamp,
    this.messageStatus,
    @required this.contactId,
    this.isFeed = false,
    this.feedId,
    this.feedCreatorUserId,
    this.feedCreatorUserName,
    this.feedCreatorImageUrl,
  });
}
