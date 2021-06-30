import 'package:flutter/foundation.dart';

class Follow {
  String followerId;
  String followedId;
  DateTime timestamp;
  String followStatus;

  Follow({
    @required this.followerId,
    @required this.followedId,
    this.timestamp,
    this.followStatus,
  });
}
