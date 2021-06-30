import 'dart:io';

import 'package:flutter/foundation.dart';

class Feed {
  final String feedId;
  String location;
  String imageUrl;
  // File image;
  int likes;
  bool isLiked;
  bool isSaved;
  String description;
  DateTime timestamp;
  final String creatorId;

  Feed({
    @required this.feedId,
    @required this.location,
    this.imageUrl,
    // this.image,
    this.likes = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.description = '',
    this.timestamp,
    @required this.creatorId,
    //@required this.placeId,
  });
}
