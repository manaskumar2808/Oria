import 'package:flutter/material.dart';

import './user_list_tile.dart';

class SentMessageRequestItem extends StatefulWidget {
  String userId;
  String name;
  String imageUrl;
  bool isRequested;
  bool isAccepted;
  bool isDeclined;
  final void Function({
    BuildContext context,
    String receiverId,
    String receiverUserName,
    String requestCaption,
  }) sendRequest;

  SentMessageRequestItem({
    this.userId,
    this.name,
    this.imageUrl,
    this.sendRequest,
    this.isRequested = false,
    this.isAccepted = false,
    this.isDeclined = false,
  });

  @override
  _SentMessageRequestItemState createState() => _SentMessageRequestItemState();
}

class _SentMessageRequestItemState extends State<SentMessageRequestItem> {
  void request() {
    this.widget.sendRequest(
          context: context,
          receiverId: this.widget.userId,
          receiverUserName: this.widget.name,
        );

    setState(() {
      this.widget.isRequested = !this.widget.isRequested;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserListTile(
      userName: this.widget.name,
      imageUrl: this.widget.imageUrl,
      singleButtonText: this.widget.isRequested ? 'Unrequest' : 'Request',
      singleButtonFn: this.request,
      buttonIsLoading: this.widget.isRequested == null,
      hasTrailingText: this.widget.isAccepted || this.widget.isDeclined,
      trailingText: this.widget.isAccepted ? "Accepted" : this.widget.isDeclined ? "Declined" : "",
    );
  }
}
