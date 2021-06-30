import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/user_provider.dart';

import './circular_loader.dart';
import './chat_bubble.dart';

class ChatList extends StatefulWidget {
  String contactId;
  String contactUserName;
  String contactImageUrl;
  
  final void Function({
    BuildContext context,
    String receiverId,
    String messageId
  }) deleteMessage;

  ChatList({
    this.contactId,
    this.contactUserName,
    this.contactImageUrl,
    this.deleteMessage,
  });

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<UserProvider>(context, listen: false).currentStaticUser;

    return StreamBuilder(
        stream: Firestore.instance
            .collection('chats')
            .document(currentUser.userId)
            .collection('contacts')
            .document(this.widget.contactId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, messagesSnapshot) {
          if (messagesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularLoader(
                thickness: 1,
              ),
            );
          }
          final messageDocs = messagesSnapshot.data.documents;
          if (messageDocs.length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.person_pin,
                    size: 80,
                  ),
                  Text(
                    'No Previous Chats',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            reverse: true,
            itemCount: messageDocs.length,
            itemBuilder: (context, index) => ChatBubble(
              messageId: messageDocs[index].documentID,
              contactId: this.widget.contactId,
              userName: messageDocs[index]['senderId'] == currentUser.userId
                  ? currentUser.userName
                  : this.widget.contactUserName,
              userProfileImage:
                  messageDocs[index]['senderId'] == currentUser.userId
                      ? currentUser.profileImageUrl
                      : this.widget.contactImageUrl,
              text: messageDocs[index]['text'],
              imageUrl: messageDocs[index]['messageImageUrl'],
              isFeed: messageDocs[index]['isFeed'] == null
                  ? false
                  : messageDocs[index]['isFeed'],
              feedCreatorUserId: messageDocs[index]['feedCreatorUserId'],
              feedCreatorUserName: messageDocs[index]['feedCreatorUserName'],
              feedCreatorImageUrl: messageDocs[index]['feedCreatorImageUrl'],
              timestamp: DateTime.parse(messageDocs[index]['timestamp']),
              isCurrentUser:
                  messageDocs[index]['senderId'] == currentUser.userId,
              deleteChatMessage: this.widget.deleteMessage,
            ),
          );
        });
  }
}
