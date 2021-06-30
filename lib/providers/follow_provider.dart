import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follow.dart';

class FollowProvider with ChangeNotifier {
  List<Follow> _followers;
  List<Follow> _followeds;

  Future<List<Follow>> get followers async {
    await this.fetchAndSetFollowers();
    return [...this._followers];
  }

  Future<List<Follow>> get followeds async {
    await this.fetchAndSetFolloweds();
    return [...this._followeds];
  }

  Future<void> fetchAndSetFollowers() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;
    final followers = await Firestore.instance
        .collection('follows')
        .document(userId)
        .collection('followers')
        .getDocuments();

    List<Follow> loadedFollowers = [];
    followers.documents.forEach((document) {
      var follow = document.data;
      loadedFollowers.add(Follow(
        followerId: follow['followerId'],
        followedId: userId,
        timestamp: DateTime.parse(follow['timestamp']),
        followStatus: follow['followStatus'],
      ));
    });

    this._followers = loadedFollowers;
  }

  Future<void> fetchAndSetFolloweds() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;
    final followeds = await Firestore.instance
        .collection('follows')
        .document(userId)
        .collection('followeds')
        .getDocuments();

    List<Follow> loadedFolloweds = [];
    followeds.documents.forEach((document) {
      var follow = document.data;
      loadedFolloweds.add(Follow(
        followerId: follow['followerId'],
        followedId: follow['followedId'],
        timestamp: DateTime.parse(follow['timestamp']),
        followStatus: follow['followStatus'],
      ));
    });

    this._followeds = loadedFolloweds;
  }

  Future<List<Follow>> userFollowers(String userId) async {
    final userFollowers = await Firestore.instance
        .collection('follows')
        .document(userId)
        .collection('followers')
        .getDocuments();

    List<Follow> loadedFollowers = [];
    userFollowers.documents.forEach((document) {
      var follow = document.data;
      loadedFollowers.add(Follow(
        followerId: follow['followerId'],
        followedId: follow['followedId'],
        timestamp: DateTime.parse(follow['timestamp']),
        followStatus: follow['followStatus'],
      ));
    });

    return loadedFollowers;
  }

  Future<List<Follow>> userFolloweds(String userId) async {
    final userFolloweds = await Firestore.instance
        .collection('follows')
        .document(userId)
        .collection('followeds')
        .getDocuments();

    List<Follow> loadedFolloweds = [];
    userFolloweds.documents.forEach((document) {
      var follow = document.data;
      loadedFolloweds.add(Follow(
        followerId: follow['followerId'],
        followedId: follow['followedId'],
        timestamp: DateTime.parse(follow['timestamp']),
        followStatus: follow['followStatus'],
      ));
    });

    return loadedFolloweds;
  }

  Future<bool> isFollowing(String userId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final currentUserId = currentUser.uid;
    final followeds = await Firestore.instance
        .collection('follows')
        .document(currentUserId)
        .collection('followeds')
        .getDocuments();

    final isFollowing = followeds.documents
            .indexWhere((document) => document.documentID == userId) !=
        -1;
    return isFollowing;
  }

  Future<bool> isFollower(String userId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final currentUserId = currentUser.uid;
    final followers = await Firestore.instance
        .collection('follows')
        .document(currentUserId)
        .collection('followers')
        .getDocuments();
    final isFollower = followers.documents
            .indexWhere((document) => document.documentID == userId) !=
        -1;
    return isFollower;
  }

  Future<void> follow({
    String followedId,
  }) async {
    await this.fetchAndSetFollowers();
    await this.fetchAndSetFolloweds();

    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;

    final isFollowing = await this.isFollowing(followedId);

    if (isFollowing) {
      await this.unFollow(followedId);
    } else {
      await Firestore.instance
          .collection('follows')
          .document(userId)
          .collection('followeds')
          .document(followedId)
          .setData({
        'followerId': userId,
        'followedId': followedId,
        'timestamp': DateTime.now().toIso8601String(),
        'followStatus': 'requested',
      });

      this._followeds.add(Follow(
            followerId: userId,
            followedId: followedId,
            timestamp: DateTime.now(),
            followStatus: 'requested',
          ));

      await Firestore.instance
          .collection('follows')
          .document(followedId)
          .collection('followers')
          .document(userId)
          .setData({
        'followerId': userId,
        'followedId': followedId,
        'timestamp': DateTime.now().toIso8601String(),
        'followStatus': 'requested',
      });
    }

    notifyListeners();
  }

  Future<void> unFollow(String unFollowedId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;
    await Firestore.instance
        .collection('follows')
        .document(userId)
        .collection('followeds')
        .document(unFollowedId)
        .delete();
    this._followeds.removeWhere((follow) => follow.followedId == unFollowedId);

    await Firestore.instance
        .collection('follows')
        .document(unFollowedId)
        .collection('followers')
        .document(userId)
        .delete();

    notifyListeners();
  }

  Future<void> accept(String followerId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;
    await Firestore.instance
        .collection('follows')
        .document(userId)
        .collection('followers')
        .document(followerId)
        .updateData({
      'followStatus': 'accepted',
    });
    final index =
        this._followers.indexWhere((follow) => follow.followerId == followerId);
    this._followers[index].followStatus = 'accepted';
    notifyListeners();
  }

  Future<void> decline(String followerId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userId = currentUser.uid;
    await Firestore.instance
        .collection('follows')
        .document(userId)
        .collection('followers')
        .document(followerId)
        .delete();
    this._followers.removeWhere((follow) => follow.followerId == followerId);
    notifyListeners();
  }
}
