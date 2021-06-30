import 'package:flutter/material.dart';
import 'package:oria/providers/comment_provider.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../widgets/comment_list.dart';
import '../widgets/comment_form.dart';

class CommentScreen extends StatelessWidget {
  static const String routeName = '/comment';
  String feedId;

  void _submitComment({
    BuildContext ctx,
    String text,
  }) async {
    await Provider.of<CommentProvider>(ctx,listen: false).addComment(
      text: text,
      feedId: feedId,
      commentorId: Provider.of<UserProvider>(ctx,listen: false).currentStaticUser.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    this.feedId = id;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Comments'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: CommentList(
                feedId: id,
              ),
            ),
            CommentForm(
                submitComment: this._submitComment,
            ),   
          ],
        ),
      ),
    );
  }
}
