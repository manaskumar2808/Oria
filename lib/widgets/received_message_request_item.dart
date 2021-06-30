import 'package:flutter/material.dart';

import './user_list_tile.dart';

class ReceivedMessageRequestItem extends StatefulWidget {
  String name;
  String imageUrl;
  bool accepted = false;
  bool rejected = false;
  String userId;

  final void Function({
    BuildContext context,
    String senderId,
    String userName,
    String imageUrl,
  }) acceptRequest;

  final void Function({
    BuildContext context,
    String senderId,
    String userName,
  }) declineRequest;

  ReceivedMessageRequestItem({
    this.userId,
    this.name,
    this.imageUrl,
    this.acceptRequest,
    this.declineRequest,
  });

  @override
  _ReceivedMessageRequestItemState createState() =>
      _ReceivedMessageRequestItemState();
}

class _ReceivedMessageRequestItemState
    extends State<ReceivedMessageRequestItem> {
  void accept() {
    this.widget.acceptRequest(
          context: context,
          senderId: this.widget.userId,
          userName: this.widget.name,
          imageUrl: this.widget.imageUrl,
        );
    setState(() {
      this.widget.accepted = !this.widget.accepted;
    });
  }

  void decline() {
    this.widget.declineRequest(
          context: context,
          senderId: this.widget.userId,
          userName: this.widget.name,
        );

    setState(() {
      this.widget.rejected = !this.widget.rejected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserListTile(
      userName: this.widget.name,
      imageUrl: this.widget.imageUrl,
      dualButton: true,
      dualButtonText1: 'Accept',
      dualButtonText2: 'Decline',
      dualButtonColor1: Colors.green,
      dualButtonColor2: Colors.red,
      dualButtonFn1: this.widget.accepted ? null : this.accept,
      dualButtonFn2: this.widget.rejected ? null : this.decline,
    );
  }
}
