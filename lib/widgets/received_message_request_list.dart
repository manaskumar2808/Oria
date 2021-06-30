import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/message_request_provider.dart';
import '../providers/user_provider.dart';
import '../providers/contact_provider.dart';

import './circular_loader.dart';
import './received_message_request_item.dart';

class ReceivedMessageRequestList extends StatelessWidget {
  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
    ));
  }

  void _acceptRequest({
    BuildContext context,
    String senderId,
    String userName,
    String imageUrl,
  }) async {
    final currentUser =
        Provider.of<UserProvider>(context, listen: false).currentStaticUser;

    try {
      await Provider.of<MessageRequestProvider>(context, listen: false)
          .acceptMessageRequest(
        senderId: senderId,
      );
      await Provider.of<ContactProvider>(context, listen: false).addContact(
        name: userName,
        contactUserId: senderId,
        imageUrl: imageUrl,
      );
      await Provider.of<ContactProvider>(context, listen: false).addSenderContact(
        senderName: currentUser.userName,
        senderUserId: currentUser.userId,
        senderImageUrl: currentUser.profileImageUrl,
      );
      final message = "You accepted $userName request";
      this._showSnackBar(context, message);
    } catch (error) {
      final errorMessage = "Can't accept at the moment!";
      this._showSnackBar(context, errorMessage);
      throw error;
    }
  }

  void _declineRequest({
    BuildContext context,
    String senderId,
    String userName,
  }) async {
    try {
      await Provider.of<MessageRequestProvider>(context, listen: false)
          .declineMessageRequest();
      final message = "You rejected $userName request";
      this._showSnackBar(context, message);
    } catch (error) {
      final errorMessage = "Can't decline at the moment!";
      this._showSnackBar(context, errorMessage);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Provider.of<MessageRequestProvider>(context, listen: false)
            .receivedMessageRequests,
        builder: (context, receivedRequestSnapshot) => receivedRequestSnapshot
                    .connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularLoader(
                  thickness: 1,
                ),
              )
            : receivedRequestSnapshot.data.length == 0
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.recent_actors,
                          size: 80,
                        ),
                        Text(
                          'No Received Requests',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: receivedRequestSnapshot.data.length,
                    itemBuilder: (context, index) => FutureBuilder(
                      future: Provider.of<UserProvider>(context, listen: false)
                          .findById(
                              receivedRequestSnapshot.data[index].senderId),
                      builder: (context,
                              receivedMessageRequestSenderSnapshot) =>
                          receivedMessageRequestSenderSnapshot
                                      .connectionState ==
                                  ConnectionState.waiting
                              ? ReceivedMessageRequestItem(
                                  name: '',
                                  imageUrl: null,
                                )
                              : ReceivedMessageRequestItem(
                                  userId: receivedMessageRequestSenderSnapshot
                                      .data.userId,
                                  name: receivedMessageRequestSenderSnapshot
                                      .data.userName,
                                  imageUrl: receivedMessageRequestSenderSnapshot
                                      .data.profileImageUrl,
                                  acceptRequest: this._acceptRequest,
                                  declineRequest: this._declineRequest,
                                ),
                    ),
                  ),
      ),
    );
  }
}
