import 'package:flutter/material.dart';

import './circular_profile_item.dart';
import './circular_loader.dart';

class ChatBubble extends StatelessWidget {
  String messageId;
  String contactId;
  String text;
  String imageUrl;
  String userName;
  String userProfileImage;
  bool isCurrentUser;
  bool isFeed;
  String feedCreatorUserId;
  String feedCreatorUserName;
  String feedCreatorImageUrl;
  DateTime timestamp;
  String messageStatus;

  final void Function(
      {BuildContext context,
      String messageId,
      String receiverId}) deleteChatMessage;

  ChatBubble(
      {this.messageId,
      this.contactId,
      this.text,
      this.imageUrl,
      this.userName,
      this.userProfileImage,
      this.isCurrentUser,
      this.isFeed = false,
      this.feedCreatorUserId,
      this.feedCreatorUserName,
      this.feedCreatorImageUrl,
      this.timestamp,
      this.messageStatus,
      this.deleteChatMessage});

  void _showMessageDialogue(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    this.deleteChatMessage(
                      context: ctx,
                      messageId: this.messageId,
                      receiverId: this.contactId,
                    );
                    Navigator.of(ctx).pop();
                  },
                  child: Text('delete message'),
                  textColor: Colors.red,
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          this.isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onLongPress: () => this._showMessageDialogue(context),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: this.isCurrentUser ? Colors.black : Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: this.isCurrentUser
                      ? Radius.circular(10)
                      : Radius.circular(0),
                  bottomRight: this.isCurrentUser
                      ? Radius.circular(0)
                      : Radius.circular(10),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProfileItem(
                        imageUrl: this.isFeed
                            ? this.feedCreatorImageUrl
                            : this.userProfileImage,
                        haveBorder: false,
                        profileRadius: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        this.isFeed ? this.feedCreatorUserName : this.userName,
                        style: TextStyle(
                            color: this.isCurrentUser
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (this.imageUrl != null && this.imageUrl.isNotEmpty)
                  Container(
                    width: 250,
                    height: 350,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: double.infinity,
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
                            child: CircularLoader(
                              diameter: 60,
                              thickness: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Image.network(
                          this.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  constraints: BoxConstraints(maxWidth: 250,minWidth: 150),
                  child: this.isFeed
                      ? RichText(
                          text: TextSpan(
                              text: this.feedCreatorUserName,
                              style: TextStyle(
                                color: this.isCurrentUser
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' ${this.text}',
                                  style: TextStyle(
                                      color: this.isCurrentUser
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        )
                      : Text(
                          this.text,
                          style: TextStyle(
                              color: this.isCurrentUser
                                  ? Colors.white
                                  : Colors.black),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
