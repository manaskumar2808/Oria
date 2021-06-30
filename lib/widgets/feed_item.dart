import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../screens/feed_detail_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/feed_form_screen.dart';
import '../screens/comment_screen.dart';

import '../widgets/circular_profile_item.dart';

import '../utilities/time.dart';

class FeedItem extends StatefulWidget {
  final String feedId;

  // feed properties
  String location = '';
  String description = '';
  String imageUrl = '';
  // File image;
  String creatorId = '';
  int likes = 0;
  bool isLiked = false;
  bool isSaved = false;
  String timestamp;

  // feed methods
  final void Function(BuildContext context, String id) likeFeed;
  final void Function(BuildContext context, String id) saveFeed;
  final void Function({BuildContext context,String feedId}) bottomShareSheet;

  // creator properties
  String creatorUserName = '';
  String creatorProfileImageUrl = '';

  final bool isDetailFeedItem;

  // widget properties

  FeedItem({
    @required this.feedId,
    this.location,
    this.description,
    // this.image,
    this.imageUrl,
    @required this.creatorId,
    this.likes,
    this.isLiked,
    this.isSaved,
    this.creatorUserName,
    this.creatorProfileImageUrl,
    this.isDetailFeedItem = false,
    this.likeFeed,
    this.saveFeed,
    this.timestamp,
    this.bottomShareSheet,
  });
  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  final double _feedSize = 650;

  final double _feedImageSize = 450;

  final double _iconSize = 30;

  void likeFeed() {
    this.widget.likeFeed(context, this.widget.feedId);
    setState(() {
      this.widget.isLiked = !this.widget.isLiked;
      if (this.widget.isLiked) {
        this.widget.likes += 1;
      } else {
        this.widget.likes -= 1;
      }
    });
  }

  void saveFeed() {
    this.widget.saveFeed(context, this.widget.feedId);
    setState(() {
      this.widget.isSaved = !this.widget.isSaved;
    });
  }

  void _feedOptions(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Text(
                  'Report inappropriate',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Text(
                  'Unfollow',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () {
                  if (Navigator.of(ctx).canPop()) {
                    Navigator.of(ctx).pop();
                  }
                  if (!this.widget.isDetailFeedItem) {
                    Navigator.of(ctx).pushNamed(FeedDetailScreen.routeName,
                        arguments: this.widget.feedId);
                  }
                },
                child: Text('go to post'),
              ),
              if (widget.creatorId ==
                  Provider.of<UserProvider>(ctx).currentStaticUser.userId)
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx)
                        .pushNamed(FeedFormScreen.routeName, arguments: {
                      'feedId': this.widget.feedId,
                      'location': this.widget.location,
                      'description': this.widget.description,
                      'imageUrl': this.widget.imageUrl,
                      'isUpdating': true,
                    });
                  },
                  child: Text('update post'),
                ),
              FlatButton(
                onPressed: () {},
                child: Text('copy link'),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Share to...'),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Mute'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bufferFeedImage() {
    return Container(
      key: ValueKey(this.widget.feedId),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(this.widget.feedId),
      height: this._feedSize,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: .25)),
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          UserProfileScreen.routeName,
                          arguments: this.widget.creatorId);
                    },
                    child: CircularProfileItem(
                      imageUrl: this.widget.creatorProfileImageUrl,
                      profileRadius: 20,
                      profileBorderWidth: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              UserProfileScreen.routeName,
                              arguments: widget.creatorId);
                        },
                        child: Text(
                          this.widget.creatorUserName,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Text(
                        this.widget.location,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => this._feedOptions(context),
                    icon: Icon(
                      Icons.more_horiz,
                      size: this._iconSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              this._bufferFeedImage(),
              GestureDetector(
                onDoubleTap: this.likeFeed,
                child: Container(
                    width: double.infinity,
                    height: this._feedImageSize,
                    child: Image.network(
                      this.widget.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: this.likeFeed,
                        icon: Icon(
                          this.widget.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: this._iconSize,
                          color:
                              this.widget.isLiked ? Colors.red : Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              CommentScreen.routeName,
                              arguments: this.widget.feedId);
                        },
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          size: this._iconSize,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () => this.widget.bottomShareSheet(
                          context: context,
                          feedId: this.widget.feedId,
                        ),
                        icon: Icon(
                          Icons.send,
                          size: this._iconSize,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: this.saveFeed,
                      icon: Icon(
                        this.widget.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        size: this._iconSize,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (this.widget.likes > 0)
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                '${this.widget.likes} likes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Text(
                    '${this.widget.creatorUserName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Text(' ${this.widget.description}'),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Text(
              '${getTime(this.widget.timestamp)} ${getAbbreviation(this.widget.timestamp, true)}',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
