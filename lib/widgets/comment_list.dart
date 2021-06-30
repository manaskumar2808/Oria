import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/comment_provider.dart';
import '../providers/user_provider.dart';

import '../widgets/circular_loader.dart';
import '../widgets/comment_item.dart';

class CommentList extends StatelessWidget {
  String feedId;

  CommentList({this.feedId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CommentProvider>(context, listen: false)
          .commentByFeedId(this.feedId),
      builder: (context, commentSnapshot) =>
          commentSnapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularLoader(
                    thickness: 1,
                  ),
                )
              : commentSnapshot.data.length == 0
                  ? Center(
                      child: Text('No Comments'),
                    )
                  : ListView.builder(
                      itemCount: commentSnapshot.data.length,
                      itemBuilder: (context, index) => FutureBuilder(
                        future: Provider.of<UserProvider>(context)
                            .findById(commentSnapshot.data[index].commentorId),
                        builder: (context, commentorSnapshot) =>
                            commentorSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CommentItem(
                                    text: commentSnapshot.data[index].text,
                                    commentorUserName: '',
                                    commentorProfileImageUrl: null,
                                    timestamp: commentSnapshot.data[index].timestamp.toString(),
                                  )
                                : CommentItem(
                                    text: commentSnapshot.data[index].text,
                                    commentorUserName:
                                        commentorSnapshot.data.userName,
                                    commentorProfileImageUrl:
                                        commentorSnapshot.data.profileImageUrl,
                                    timestamp: commentSnapshot.data[index].timestamp.toString(),
                                  ),
                      ),
                    ),
    );
  }
}
