import 'package:flutter/foundation.dart';

class Story {
  String storyId;
  String storyTitle;
  String storyCaption;
  String storyImageUrl;
  String storyTellerUserId;
  String storyTellerUserName;
  String storyTellerProfileImage;
  DateTime timestamp;

  Story({
    @required this.storyId,
    this.storyTitle,
    this.storyCaption,
    this.storyImageUrl,
    @required this.storyTellerUserId,
    @required this.storyTellerUserName,
    this.storyTellerProfileImage,
    @required this.timestamp,
  });
}
