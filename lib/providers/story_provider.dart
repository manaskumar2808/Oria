import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/story.dart';

class StoryProvider with ChangeNotifier {
  List<Story> _stories = [];

  Future<List<Story>> get stories async {
    await this.fetchAndSetLatestStories();
    return this._stories;
  }

  Future<void> fetchAndSetLatestStories() async {
    final stories = await Firestore.instance.collection('stories').orderBy('timestamp',descending: true).where('timestamp',isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(hours: 24)).toIso8601String()).getDocuments();

    List<Story> loadedStories = [];
    stories.documents.forEach((document) {
      final story = document.data;
      loadedStories.add(Story(
        storyId: document.documentID,
        storyTitle: story['storyTitle'],
        storyCaption: story['storyCaption'],
        storyImageUrl: story['storyImageUrl'],
        storyTellerUserId: story['storyTellerUserId'],
        storyTellerUserName: story['storyTellerUserName'],
        storyTellerProfileImage: story['storyTellerProfileImage'],
        timestamp: DateTime.parse(story['timestamp']),
      ));
    });
    this._stories = loadedStories;
  }


  Future<void> fetchAndSetStories() async {
    final stories = await Firestore.instance.collection('stories').getDocuments();

    List<Story> loadedStories = [];
    stories.documents.forEach((document) {
      final story = document.data;
      loadedStories.add(Story(
        storyId: document.documentID,
        storyTitle: story['storyTitle'],
        storyCaption: story['storyCaption'],
        storyImageUrl: story['storyImageUrl'],
        storyTellerUserId: story['storyTellerUserId'],
        storyTellerUserName: story['storyTellerUserName'],
        storyTellerProfileImage: story['storyTellerProfileImage'],
        timestamp: DateTime.parse(story['timestamp']),
      ));
    });
    this._stories = loadedStories;
  }

  Future<void> addStory({
    String storyTitle,
    String storyCaption,
    String storyImageUrl,
    String storyTellerUserId,
    String storyTellerUserName,
    String storyTellerProfileImage,
  }) async {
    final storyRef = Firestore.instance.collection('stories').document();
    final storyId = storyRef.documentID;

    storyRef.setData({
      'storyTitle': storyTitle,
      'storyCaption': storyCaption,
      'storyImageUrl': storyImageUrl,
      'storyTellerUserId': storyTellerUserId,
      'storyTellerUserName': storyTellerUserName,
      'storyTellerProfileImage': storyTellerProfileImage,
      'timestamp': DateTime.now().toIso8601String(),
    });

    this._stories.add(Story(
          storyId: storyId,
          storyTitle: storyTitle,
          storyCaption: storyCaption,
          storyImageUrl: storyImageUrl,
          storyTellerUserId: storyTellerUserId,
          storyTellerUserName: storyTellerUserName,
          storyTellerProfileImage: storyTellerProfileImage,
          timestamp: DateTime.now(),
        ));

    notifyListeners();
  }

  Future<void> removeStory({String storyId}) async {
    await Firestore.instance.collection('stories').document(storyId).delete();
    this._stories.removeWhere((story) => story.storyId == storyId);
    notifyListeners();
  }
}
