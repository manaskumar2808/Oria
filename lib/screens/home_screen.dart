import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/app_drawer_screen.dart';
import '../screens/message_screen.dart';
import '../screens/story_form_screen.dart';

import '../providers/user_provider.dart';
import '../providers/feed_provider.dart';
import '../providers/contact_provider.dart';
import '../providers/message_provider.dart';

import '../widgets/feed_list.dart';
import '../widgets/story_list.dart';
import '../widgets/user_list_tile.dart';
import '../widgets/circular_loader.dart';

class HomeScreen extends StatelessWidget {
  void _likeFeed(BuildContext context, String id) async {
    try {
      await Provider.of<FeedProvider>(context, listen: false).likeFeed(id);
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

  void _shareFeed(
      {BuildContext context, String receiverId, String feedId}) async {
    final feed = await Provider.of<FeedProvider>(context, listen: false)
        .findById(feedId);
    final creator = await Provider.of<UserProvider>(context, listen: false)
        .findById(feed.creatorId);
    await Provider.of<MessageProvider>(context, listen: false).addMessage(
      text: feed.description,
      messageImageUrl: feed.imageUrl,
      receiverId: receiverId,
      contactId: receiverId,
      isFeed: true,
      feedCreatorUserId: feed.creatorId,
      feedCreatorUserName: creator.userName,
      feedCreatorImageUrl: creator.profileImageUrl,
    );
  }

  void _unShareFeed(
      {BuildContext context, String receiverId, String feedId}) async {
    await Provider.of<MessageProvider>(context, listen: false).removeMessage(
      contactId: receiverId,
      receiverId: receiverId,
      removeByFeedId: true,
      feedId: feedId,
    );
  }

  void _bottomShareSheet({BuildContext context, String feedId}) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              '  Share with',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              thickness: .5,
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<ContactProvider>(context, listen: false)
                    .contacts,
                builder: (context, contactsSnapshot) =>
                    contactsSnapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: CircularLoader(
                              thickness: 1,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: contactsSnapshot.data.length,
                            itemBuilder: (ctx, index) {
                              return UserListTile(
                                userName: contactsSnapshot.data[index].name,
                                imageUrl: contactsSnapshot.data[index].imageUrl,
                                singleButtonText: 'Send',
                                singleButtonColor: Colors.blue,
                                singleButtonToggleText: 'Sent',
                                singleButtonToggleColor: Colors.black,
                                hasButton: true,
                                buttonIsLoading: false,
                                singleButtonFn: () {
                                  this._shareFeed(
                                    context: context,
                                    feedId: feedId,
                                    receiverId:
                                        contactsSnapshot.data[index].contactId,
                                  );
                                },
                                singleButtonToggleFn: null,
                                toggleEnabled: true,
                              );
                            }),
              ),
            ),
            Divider(
              thickness: .5,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Done'),
                textColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(StoryFormScreen.routeName);
          },
          icon: Icon(
            Icons.camera_alt,
            size: 30,
          ),
        ),
        title: Text(
          'Oria',
          style: TextStyle(
            color: Color.fromRGBO(5, 5, 5, 1),
            fontFamily: 'BillionDreams_PERSONAL',
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.send,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(MessageScreen.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StoryList(),
            FeedList(
              likeFeed: this._likeFeed,
              saveFeed: this._saveFeed,
              bottomShareSheet: this._bottomShareSheet,
            ),
          ],
        ),
      ),
    );
  }
}
