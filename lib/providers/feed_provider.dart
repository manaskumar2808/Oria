import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/feed.dart';

class FeedProvider with ChangeNotifier {
  List<Feed> _feeds = [];
  String userId;

  Future<List<Feed>> get feeds async {
    await this.setUserId();
    await this.fetchSetFeeds();
    return [...this._feeds];
  }

  Future<Feed> findById(String id) async {
    return this._feeds.firstWhere((feed) => feed.feedId == id);
  }

  Future<List<Feed>> findByCreatorId(
      {@required String id, String removeId = '-1'}) async {
    return this
        ._feeds
        .where((feed) => feed.creatorId == id && feed.feedId != removeId)
        .toList();
  }

  Future<void> setUserId() async {
    final user = await FirebaseAuth.instance.currentUser();
    this.userId = user.uid;
  }

  Future<bool> isFeedLiked(String id) async {
    final hasLikedEver =
        Firestore.instance.collection('liked-feeds').document(this.userId) ==
                null
            ? false
            : true;
    final likedDocuments = !hasLikedEver
        ? null
        : await Firestore.instance
            .collection('liked-feeds')
            .document(this.userId)
            .collection(this.userId)
            .getDocuments();
    final value = likedDocuments == null || likedDocuments.documents.isEmpty
        ? null
        : likedDocuments.documents
            .firstWhere((document) => document.documentID == id)
            .data['isLiked'];
    bool isLiked = (value == null) ? false : value;

    return isLiked;
  }

  bool isLiked(String id) {
    var localFeed = this._feeds.firstWhere((feed) => feed.feedId == id);
    return localFeed.isLiked;
  }

  int likes(String id) {
    var localFeed = this._feeds.firstWhere((feed) => feed.feedId == id);
    return localFeed.likes;
  }

  Future<void> likeFeed(String id) async {
    var feed = await Firestore.instance.collection('feeds').document(id).get();
    final feedIndex = this._feeds.indexWhere((feed) => feed.feedId == id);

    final isLiked = this._feeds[feedIndex].isLiked;

    await Firestore.instance
        .collection('liked-feeds')
        .document(this.userId)
        .collection(this.userId)
        .document(id)
        .setData({
      'isLiked': !isLiked,
    });

    this._feeds[feedIndex].isLiked = !isLiked;

    if (!isLiked) {
      await Firestore.instance.collection('feeds').document(id).updateData({
        'likes': feed.data['likes'] + 1,
      });
      this._feeds[feedIndex].likes += 1;
      notifyListeners();
    } else {
      await Firestore.instance.collection('feeds').document(id).updateData({
        'likes': feed.data['likes'] - 1,
      });
      this._feeds[feedIndex].likes -= 1;
      notifyListeners();
    }

    // var feed = this.findById(id);
    // final url =
    //     'https://oria-12369.firebaseio.com/user-${this.userId}/liked-feeds/$id.json?auth=${this.authToken}';

    // if (feed.isLiked) {
    //   final unlikeResponse =
    //       await http.put(url, body: json.encode({'isLiked': false}));
    //   if (unlikeResponse.statusCode <= 400) {
    //     feed.isLiked = false;
    //     feed.likes -= 1;
    //     notifyListeners();
    //   }
    // } else {
    //   final likeResponse = await http.put(url,
    //       body: json.encode({
    //         'isLiked': true,
    //       }));
    //   if (likeResponse.statusCode <= 400) {
    //     feed.isLiked = true;
    //     feed.likes += 1;
    //     notifyListeners();
    //   }
    // }
  }

  Future<void> saveFeed(String id) async {
    final feedIndex = this._feeds.indexWhere((feed) => feed.feedId == id);

    var isSaved = this._feeds[feedIndex].isSaved;

    await Firestore.instance
        .collection('saved-feeds')
        .document(this.userId)
        .collection(this.userId)
        .document(id)
        .setData({
      'isSaved': !isSaved,
    });

    this._feeds[feedIndex].isSaved = !isSaved;

    notifyListeners();

    // var feed = this.findById(id);
    // final url =
    //     'https://oria-12369.firebaseio.com/user-${this.userId}/saved-feeds/$id.json?auth=${this.authToken}';
    // if (feed.isSaved) {
    //   final unsaveResponse = await http.put(url,
    //       body: json.encode({
    //         'isSaved': false,
    //       }));
    //   if (unsaveResponse.statusCode <= 400) {
    //     feed.isSaved = false;
    //     notifyListeners();
    //   }
    // } else {
    //   final saveResponse = await http.put(url,
    //       body: json.encode({
    //         'isSaved': true,
    //       }));
    //   if (saveResponse.statusCode <= 400) {
    //     feed.isSaved = true;
    //     notifyListeners();
    //   }
    // }
  }

  List<Feed> getSavedFeeds() {
    return this._feeds.where((feed) => feed.isSaved).toList();
  }

  List<Feed> getCurrentUserFeeds({String removeId = ''}) {
    final id = this.userId;
    return removeId.isEmpty
        ? this._feeds.where((feed) => feed.creatorId == id).toList()
        : this
            ._feeds
            .where(
                (feed) => (feed.creatorId == id) && (feed.feedId != removeId))
            .toList();
  }

  List<Feed> getUserFeeds(String id, {String removeId = ''}) {
    return removeId.isEmpty
        ? this._feeds.where((feed) => feed.creatorId == id).toList()
        : this
            ._feeds
            .where(
                (feed) => (feed.creatorId == id) && (feed.feedId != removeId))
            .toList();
  }

  Future<void> fetchSetFeeds() async {
    // final url =
    //     'https://oria-12369.firebaseio.com/feeds.json?auth=${this.authToken}';
    // final response = await http.get(url);
    // var responseData = json.decode(response.body) as Map<String, dynamic>;

    // final likesUrl =
    //     'https://oria-12369.firebaseio.com/user-${this.authToken}/liked-feeds.json';
    // final likeResponse = await http.get(likesUrl);
    // final likeResponseData =
    //     json.decode(likeResponse.body) as Map<String, dynamic>;

    // final saveUrl =
    //     'https://oria-12369.firebaseio.com/user-${this.authToken}/saved-feeds.json';
    // final saveResponse = await http.get(saveUrl);
    // final saveResponseData =
    //     json.decode(saveResponse.body) as Map<String, dynamic>;

    var feeds = await Firestore.instance
        .collection('feeds')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    var likedFeeds = await Firestore.instance
        .collection('liked-feeds')
        .document(this.userId)
        .collection(this.userId)
        .getDocuments();

    var savedFeeds = await Firestore.instance
        .collection('saved-feeds')
        .document(this.userId)
        .collection(this.userId)
        .getDocuments();

    List<Feed> loadedFeeds = [];

    feeds.documents.forEach((document) {
      var feed = document.data;

      var isLiked = likedFeeds.documents.isEmpty
          ? false
          : likedFeeds.documents.indexWhere((likedFeed) =>
                      likedFeed.documentID == document.documentID) ==
                  -1
              ? false
              : likedFeeds.documents
                  .firstWhere((likedFeed) =>
                      likedFeed.documentID == document.documentID)
                  .data['isLiked'];

      var isSaved = savedFeeds.documents.isEmpty
          ? false
          : savedFeeds.documents.indexWhere((savedFeed) =>
                      savedFeed.documentID == document.documentID) ==
                  -1
              ? false
              : savedFeeds.documents
                  .firstWhere((savedFeed) =>
                      savedFeed.documentID == document.documentID)
                  .data['isSaved'];

      loadedFeeds.add(Feed(
        feedId: document.documentID,
        location: feed['location'],
        description: feed['description'],
        // image: feed['image'],
        imageUrl: feed['imageUrl'],
        creatorId: feed['creatorId'],
        timestamp: DateTime.parse(feed['timestamp']),
        likes: feed['likes'],
        isLiked: isLiked,
        isSaved: isSaved,
      ));
    });

    // feeds.forEach((id, feed) {
    //   loadedFeeds.add(
    //     Feed(
    //       feedId: id,
    //       creatorId: feed['creatorId'],
    //       location: feed['location'],
    //       image: feed['image'],
    //       imageUrl: feed['imageUrl'],
    //       likes: feed['likes'],
    //       isLiked: likeResponseData['$id']['isLiked'] == null
    //           ? false
    //           : likeResponseData['$id']['isLiked'],
    //       isSaved: saveResponseData['$id']['isSaved'] == null
    //           ? false
    //           : saveResponseData['$id']['isSaved'],
    //       description: feed['description'],
    //     ),
    //   );
    // });

    this._feeds = loadedFeeds;
  }

  Future<void> addFeed({
    String postLocation,
    File postImage,
    String postImageUrl,
    String postDescription,
  }) async {
    // final url =
    //     'https://oria-12369.firebaseio.com/feeds.json?auth=${this.authToken}';
    // final response = await http.post(url,
    //     body: json.encode({
    //       'location': postLocation,
    //       'image': postImage,
    //       'imageUrl': postImageUrl,
    //       'description': postDescription,
    //       'creatorId': this.userId,
    //       'likes': 0,
    //       'isLiked': false,
    //       'isSaved': false,
    //     }));

    final feedRef = Firestore.instance.collection('feeds').document();

    final feedId = feedRef.documentID;

    if (postImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('feed_image')
          .child(feedId + '.jpg');
      await ref.putFile(postImage).onComplete;
      postImageUrl = await ref.getDownloadURL();
    }

    await feedRef.setData({
      'location': postLocation,
      // 'image': postImage,
      'imageUrl': postImageUrl,
      'description': postDescription,
      'creatorId': this.userId,
      'timestamp': DateTime.now().toIso8601String(),
      'likes': 0,
      'isLiked': false,
      'isSaved': false,
    });

    final feed = Feed(
      feedId: feedId,
      location: postLocation,
      // image: postImage,
      imageUrl: postImageUrl,
      description: postDescription,
      creatorId: this.userId,
      timestamp: DateTime.now(),
      likes: 0,
      isLiked: false,
      isSaved: false,
    );

    this._feeds.add(feed);
    notifyListeners();
  }

  Future<void> updateFeed(String id,
      {String newLocation = '',
      File newImage,
      String newImageUrl = '',
      String newDescription = ''}) async {
    // final url =
    //     'https://oria-12369.firebaseio.com/feeds/$id.json?auth=${this.authToken}';

    // final response = await http.patch(url,
    //     body: json.encode({
    //       'location': newLocation,
    //       'image': newImage,
    //       'imageUrl': newImageUrl,
    //       'description': newDescription,
    //     }));

    final feedIndex = this._feeds.indexWhere((feed) => feed.feedId == id);

    final oldFeed = this._feeds[feedIndex];
    this._feeds[feedIndex].location =
        newLocation.isEmpty ? oldFeed.location : newLocation;
    // this._feeds[feedIndex].image = newImage == null ? oldFeed.image : newImage;
    this._feeds[feedIndex].imageUrl =
        newImageUrl.isEmpty ? oldFeed.imageUrl : newImageUrl;
    this._feeds[feedIndex].description =
        newDescription.isEmpty ? oldFeed.description : newDescription;

    await Firestore.instance.collection('feeds').document(id).updateData({
      'location': newLocation.isEmpty ? oldFeed.location : newLocation,
      // 'image': newImage == null ? oldFeed.image : newImage,
      'imageUrl': newImageUrl.isEmpty ? oldFeed.imageUrl : newImageUrl,
      'description':
          newDescription.isEmpty ? oldFeed.description : newDescription,
    });

    // if (response.statusCode < 400) {
    //   var oldFeedIndex = this._feeds.indexWhere((feed) => feed.feedId == id);
    //   if (newLocation != null && newLocation.isNotEmpty) {
    //     this._feeds[oldFeedIndex].location = newLocation;
    //   }
    //   if (newImage != null) {
    //     this._feeds[oldFeedIndex].image = newImage;
    //   }
    //   if (newDescription != null && newDescription.isNotEmpty) {
    //     this._feeds[oldFeedIndex].description = newDescription;
    //   }
    notifyListeners();
  }

  Future<void> removeFeed(String id) async {
    await Firestore.instance.collection('feeds').document(id).delete();
    // final url =
    //     'https://oria-12369.firebaseio.com/feeds/$id.json?auth=${this.authToken}';
    // final response = await http.delete(url);
    // if (response.statusCode < 400) {
    //   this._feeds.removeWhere((feed) => feed.feedId == id);
    // }
    this._feeds.removeWhere((feed) => feed.feedId == id);
    notifyListeners();
  }
}
