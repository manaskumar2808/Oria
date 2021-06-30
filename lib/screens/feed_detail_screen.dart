import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/feed_provider.dart';
import '../providers/user_provider.dart';

import '../widgets/feed_item.dart';
import '../widgets/feed_grid.dart';
import '../widgets/circular_loader.dart';

class FeedDetailScreen extends StatefulWidget {
  static const String routeName = '/feed-detail';

  @override
  _FeedDetailScreenState createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {

  void _likeFeed(BuildContext context, String id) async {
    try {
      await Provider.of<FeedProvider>(context,listen: false).likeFeed(id);
    } catch (error) {
      throw error;
    }
  }

  void _saveFeed(BuildContext context, String id) async {
    try {
      await Provider.of<FeedProvider>(context, listen: false).saveFeed(id);
    } catch (error) {
      throw error;
    }
  }


  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    // final currentFeed = Provider.of<FeedProvider>(context).findById(id);
    // final currentCreator =
    //     Provider.of<UserProvider>(context).findById(currentFeed.creatorId);
    // final currentCreatorFeeds = Provider.of<FeedProvider>(context)
    //     .findByCreatorId(id: currentFeed.creatorId,removeId: id);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Post'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: Provider.of<FeedProvider>(context,listen: false).findById(id),
          builder: (ctx, feedSnapshot) {
            if (feedSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              );
            }
            return Container(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: Provider.of<UserProvider>(context).findById(feedSnapshot.data.creatorId),
                  builder: (context,creatorSnapshot) => creatorSnapshot.connectionState == ConnectionState.waiting ? 
                  Center(
                    child: CircularLoader(
                      thickness: 1,
                    ),
                  ) : Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FeedItem(
                          feedId: feedSnapshot.data.feedId,
                          location: feedSnapshot.data.location,
                          description: feedSnapshot.data.description,
                          creatorId: feedSnapshot.data.creatorId.toString().trim(),
                          // image: feedSnapshot.data.image,
                          imageUrl: feedSnapshot.data.imageUrl,
                          likes: feedSnapshot.data.likes,
                          isLiked: feedSnapshot.data.isLiked,
                          isSaved: feedSnapshot.data.isSaved,
                          creatorUserName: creatorSnapshot.data.userName,
                          creatorProfileImageUrl: creatorSnapshot.data.profileImageUrl,
                          likeFeed: this._likeFeed,
                          saveFeed: this._saveFeed,
                          timestamp: feedSnapshot.data.timestamp.toString(),
                          isDetailFeedItem: true,
                      ),               
                      Row(
                        children: <Widget>[
                          Text('  More posts by '),
                          Text(
                            "${creatorSnapshot.data.userName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),              
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                          future: Provider.of<FeedProvider>(context)
                              .findByCreatorId(id: feedSnapshot.data.creatorId),
                          builder: (ctx, creatorFeedsSnapshot) {
                            if (creatorFeedsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                child: Center(
                                  child: CircularLoader(),
                                ),
                              );
                            }
                            return LimitedBox(
                              maxHeight: 400,
                              child: FeedGrid(
                                feedList: creatorFeedsSnapshot.data,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
