import 'package:flutter/material.dart';
import 'package:oria/providers/contact_provider.dart';
import 'package:provider/provider.dart';

import '../providers/message_request_provider.dart';
import '../providers/user_provider.dart';

import './circular_loader.dart';
import './sent_message_request_item.dart';

class SentMessageRequestList extends StatelessWidget {
  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
    ));
  }

  void _sendRequest({
    BuildContext context,
    String receiverId,
    String receiverUserName,
    String requestCaption,
  }) async {
    try {
      await Provider.of<MessageRequestProvider>(context, listen: false)
          .addMessageRequest(
        receiverId: receiverId,
        requestCaption: requestCaption,
      );
      final message = "Request sent to $receiverUserName";
      this._showSnackBar(context, message);
    } catch (error) {
      final errorMessage = "Error sending request";
      this._showSnackBar(context, errorMessage);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Provider.of<MessageRequestProvider>(context, listen: false)
            .deliveredMessageRequests,
        builder: (context, deliveredRequestSnapshot) => deliveredRequestSnapshot
                    .connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularLoader(
                  thickness: 1,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text('Sent Requests'),
                    ),                  
                    if (deliveredRequestSnapshot.data.length != 0)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: deliveredRequestSnapshot.data.length,
                        itemBuilder: (context, index) => FutureBuilder(
                            future: Provider.of<UserProvider>(context,
                                    listen: false)
                                .findById(deliveredRequestSnapshot
                                    .data[index].receiverId),
                            builder:
                                (context, deliveredRequestReceiverSnapshot) {
                              if (deliveredRequestReceiverSnapshot
                                      .connectionState ==
                                  ConnectionState.waiting) {
                                return SentMessageRequestItem(
                                  name: '',
                                  imageUrl: null,
                                );
                              }

                              return SentMessageRequestItem(
                                userId: deliveredRequestReceiverSnapshot
                                    .data.userId,
                                name: deliveredRequestReceiverSnapshot
                                    .data.userName,
                                imageUrl: deliveredRequestReceiverSnapshot
                                    .data.profileImageUrl,
                                isRequested: true,
                                isAccepted: deliveredRequestSnapshot.data[index].requestStatus == 'accepted',
                                isDeclined: deliveredRequestSnapshot.data[index].requestStatus == 'rejected',
                                sendRequest: this._sendRequest,
                              );
                            }),
                      ),
                    Divider(
                      thickness: .50,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text('Search For Contacts'),
                    ),
                    Container(
                      child: FutureBuilder(
                        future:
                            Provider.of<ContactProvider>(context, listen: false)
                                .notContacts,
                        builder: (ctx, otherUsersSnapshot) => otherUsersSnapshot
                                    .connectionState ==
                                ConnectionState.waiting
                            ? Center(
                                child: CircularLoader(
                                  thickness: 1,
                                ),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: otherUsersSnapshot.data.length,
                                itemBuilder: (context, index) =>
                                    FutureBuilder(
                                      future: Provider.of<MessageRequestProvider>(context,listen: false).isRequested(otherUsersSnapshot.data[index].userId),
                                      builder: (ctx,isRequestedSnapshot) => isRequestedSnapshot.connectionState == ConnectionState.waiting ?
                                      SentMessageRequestItem(
                                        userId: otherUsersSnapshot.data[index].userId,
                                        name: otherUsersSnapshot.data[index].userName,
                                        imageUrl: otherUsersSnapshot
                                            .data[index].profileImageUrl,
                                        sendRequest: this._sendRequest,
                                        isRequested: false,
                                      ) : SentMessageRequestItem(
                                        userId: otherUsersSnapshot.data[index].userId,
                                        name: otherUsersSnapshot.data[index].userName,
                                        imageUrl: otherUsersSnapshot
                                            .data[index].profileImageUrl,
                                        sendRequest: this._sendRequest,
                                        isRequested: isRequestedSnapshot.data,
                                      ),
                                    ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
