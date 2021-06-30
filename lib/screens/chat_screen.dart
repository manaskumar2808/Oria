import 'package:flutter/material.dart';
import 'package:oria/models/message.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import '../providers/message_provider.dart';

import '../widgets/chat_list.dart';
import '../widgets/chat_form.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';

  void _submitChatMessage(
      {BuildContext context,
      String text,
      File image,
      String imageUrl,
      String receiverId}) async {
    await Provider.of<MessageProvider>(context, listen: false).addMessage(
      text: text,
      messageImage: image,
      messageImageUrl: imageUrl,
      receiverId: receiverId,
      contactId: receiverId,
    );
  }

  void _deleteChatMessage(
      {BuildContext context, String messageId, String receiverId}) async {
    await Provider.of<MessageProvider>(context, listen: false).removeMessage(
      contactId: receiverId,
      receiverId: receiverId,
      messageId: messageId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final contactId = arguments['contactId'];
    final userName = arguments['userName'];
    final profileImageUrl = arguments['profileImageUrl'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(userName),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ChatList(
                contactId: contactId,
                contactUserName: userName,
                contactImageUrl: profileImageUrl,
                deleteMessage: this._deleteChatMessage,
              ),
            ),
            ChatForm(
              contactId: contactId,
              submitChatMessage: this._submitChatMessage,
            ),
          ],
        ),
      ),
    );
  }
}
