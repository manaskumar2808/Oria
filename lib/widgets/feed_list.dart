import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/feed_item.dart';
import '../widgets/circular_profile_item.dart';

import '../models/feed.dart';

import '../providers/feed_provider.dart';
import '../providers/user_provider.dart';

class FeedList extends StatelessWidget {
  List<Feed> feeds;
  final void Function(BuildContext context, String id) likeFeed;
  final void Function(BuildContext context, String id) saveFeed;
  final void Function({BuildContext context,String feedId}) bottomShareSheet;

  FeedList({this.likeFeed, this.saveFeed, this.bottomShareSheet});

  final _feedSize = 650.00;
  final _feedImageSize = 450.00;

  Widget _bufferFeedImage() {
    return Container(
      width: double.infinity,
      height: this._feedImageSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
          colors: [
            Colors.white,
            Colors.black54,
          ],
        ),
      ),
      child: Center(
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }

  Widget _bufferFeed() {
    return Container(
      height: this._feedSize,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: .25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircularProfileItem(
                  imageUrl: null,
                  haveBorder: true,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
          this._bufferFeedImage(),
          Container(
            width: double.infinity,
            height: (this._feedSize - this._feedImageSize - 80),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, currentUserSnapshot) {
          if (currentUserSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 130,
              child: SizedBox(
                height: 130,
              ),
            );
          }
          return Container(
            child: FutureBuilder(
              future: Provider.of<FeedProvider>(context, listen: false).feeds,
              builder: (context, feedSnapshot) {
                if (feedSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 300,
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  );
                }

                return feedSnapshot.data == null ||
                        feedSnapshot.data.length == 0
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),
                            Icon(
                              Icons.camera_alt,
                              size: 80,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'No Feeds To View',
                              style: TextStyle(fontSize: 23),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: feedSnapshot.data.length,
                        itemBuilder: (ctx, index) {
                          return FutureBuilder(
                            future: Provider.of<UserProvider>(context)
                                .findById(feedSnapshot.data[index].creatorId),
                            builder: (context, creatorSnapshot) =>
                                creatorSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? this._bufferFeed()
                                    : FeedItem(
                                        feedId: feedSnapshot.data[index].feedId
                                            .toString()
                                            .trim(),
                                        location:
                                            feedSnapshot.data[index].location,
                                        description: feedSnapshot
                                            .data[index].description,
                                        // image: feedSnapshot.data[index].image,
                                        imageUrl:
                                            feedSnapshot.data[index].imageUrl,
                                        creatorId: feedSnapshot
                                            .data[index].creatorId
                                            .toString()
                                            .trim(),
                                        likes: feedSnapshot.data[index].likes,
                                        isLiked:
                                            feedSnapshot.data[index].isLiked,
                                        isSaved:
                                            feedSnapshot.data[index].isSaved,
                                        creatorUserName:
                                            creatorSnapshot.data.userName,
                                        creatorProfileImageUrl: creatorSnapshot
                                            .data.profileImageUrl,
                                        likeFeed: this.likeFeed,
                                        saveFeed: this.saveFeed,
                                        timestamp: feedSnapshot
                                            .data[index].timestamp
                                            .toString(),
                                        bottomShareSheet: this.bottomShareSheet,
                                      ),
                          );
                        });
              },
            ),
          );
        });
  }
}
