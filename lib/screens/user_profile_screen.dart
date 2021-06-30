import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/feed_provider.dart';
import '../providers/user_provider.dart';
import '../providers/follow_provider.dart';

import '../screens/profile_edit_screen.dart';
import '../screens/follow_screen.dart';

import '../widgets/circular_loader.dart';
import '../widgets/circular_profile_item.dart';
import '../widgets/feed_grid.dart';

import '../models/feed.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user-profile-screen';

  final bool isCurrentUser;

  UserProfileScreen({this.isCurrentUser = false});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  // user fields

  final double _profileCountSize = 18;

  TabController _tabController;

  @override
  void initState() {
    this._tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    this._tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    // final id = Provider.of<AuthProvider>(context).userId;

    // final userId = this.widget.isCurrentUser
    //     ? id
    //     : ModalRoute.of(context).settings.arguments;
    // final user = Provider.of<UserProvider>(context).findByAuthId(userId);
    // final userFeeds =
    //     Provider.of<FeedProvider>(context).findByCreatorId(id: userId);
    // final userSavedFeeds = Provider.of<FeedProvider>(context).getSavedFeeds();
    List<Feed> userFeeds = this.widget.isCurrentUser
        ? Provider.of<FeedProvider>(context).getCurrentUserFeeds()
        : Provider.of<FeedProvider>(context).getUserFeeds(id);
    List<Feed> userSavedFeeds = this.widget.isCurrentUser
        ? Provider.of<FeedProvider>(context).getSavedFeeds()
        : [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Profile'),
      ),
      body: FutureBuilder(
        future: this.widget.isCurrentUser
            ? Provider.of<UserProvider>(context).currentUser
            : Provider.of<UserProvider>(context).findById(id),
        builder: (context, userSnapshot) => userSnapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularLoader(
                  thickness: 1,
                ),
              )
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 140,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 4,
                              child: Column(
                                children: <Widget>[
                                  CircularProfileItem(
                                    imageUrl: userSnapshot.data.profileImageUrl,
                                    haveBorder: false,
                                    profileRadius: 60,
                                  ),
                                  if (userSnapshot.data.firstName != null &&
                                      userSnapshot.data.lastName != null)
                                    FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                            '${userSnapshot.data.firstName} ${userSnapshot.data.lastName}')),
                                ],
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      userSnapshot.data.userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      userSnapshot.data.email,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (this.widget.isCurrentUser)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ProfileEditScreen.routeName);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.black,
                            textColor: Colors.white,
                          ),
                        ),
                      Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    userFeeds.length.toString(),
                                    style: TextStyle(
                                        fontSize: this._profileCountSize),
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                        fontSize: this._profileCountSize),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  FutureBuilder(
                                    future: Provider.of<FollowProvider>(context,listen: false).userFollowers(userSnapshot.data.userId),
                                    builder: (ctx,followersSnapshot) => followersSnapshot.connectionState == ConnectionState.waiting ? Text(
                                      '0',
                                      style: TextStyle(
                                          fontSize: this._profileCountSize),
                                    ) : Text(
                                      followersSnapshot.data.length.toString(),
                                      style: TextStyle(
                                          fontSize: this._profileCountSize),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(FollowScreen.routeName,arguments: {
                                            'id': userSnapshot.data.userId,
                                            'default': 'followers',
                                            'index': 0,
                                          });
                                    },
                                    child: Text(
                                      'Followers',
                                      style: TextStyle(
                                          fontSize: this._profileCountSize),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  FutureBuilder(
                                    future: Provider.of<FollowProvider>(context,listen: false).userFolloweds(userSnapshot.data.userId),
                                    builder: (ctx, followedsSnapshot) => followedsSnapshot.connectionState == ConnectionState.waiting ? Text(
                                      '0',
                                      style: TextStyle(
                                          fontSize: this._profileCountSize),
                                    ) : Text(
                                    followedsSnapshot.data.length.toString(),
                                    style: TextStyle(
                                        fontSize: this._profileCountSize),
                                  ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(FollowScreen.routeName,arguments: {
                                            'id': userSnapshot.data.userId,
                                            'default': 'following',
                                            'index': 1,
                                          });
                                    },
                                    child: Text(
                                      'Following',
                                      style: TextStyle(
                                          fontSize: this._profileCountSize),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: .5),
                          ),
                        ),
                        child: TabBar(
                          controller: this._tabController,
                          indicator: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.black, width: 2)),
                          ),
                          tabs: <Widget>[
                            Tab(
                              icon: Icon(Icons.grid_on),
                            ),
                            Tab(
                              icon: Icon(Icons.account_box),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.width / 3) *
                            (userFeeds.length > userSavedFeeds.length
                                    ? (userFeeds.length / 3 +
                                        (userFeeds.length % 3 == 0 ? 0 : 1))
                                    : (userSavedFeeds.length / 3 +
                                        (userSavedFeeds.length % 3 == 0
                                            ? 0
                                            : 1)))
                                .toDouble(),
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: this._tabController,
                          children: <Widget>[
                            FeedGrid(
                              feedList: userFeeds,
                              emptyGridMessage: 'Your posts will appear here',
                            ),
                            if (this.widget.isCurrentUser)
                              FeedGrid(
                                feedList: userSavedFeeds,
                                emptyGridMessage:
                                    'Only you can see your saved feeds',
                              ),
                            if (!this.widget.isCurrentUser)
                              Container(
                                height: 100,
                                child: Center(
                                  child: Text('Saved feeds appear here'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
