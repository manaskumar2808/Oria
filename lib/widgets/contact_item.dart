import 'package:flutter/material.dart';

import './user_list_tile.dart';

import '../screens/chat_screen.dart';

class ContactItem extends StatelessWidget {
  final String contactId;
  final String name;
  final String imageUrl;

  ContactItem({
    this.contactId,
    this.name,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: {
          'contactId': this.contactId,
          'userName': this.name,
          'profileImageUrl': this.imageUrl,
        });
      },
      child: UserListTile(
        imageUrl: this.imageUrl,
        userName: this.name,
        icon: Icon(Icons.camera_alt),
        hasButton: false,
        hasIcon: true,
      ),
    );
  }
}
