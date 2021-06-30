import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../widgets/circular_profile_item.dart';

class CommentForm extends StatefulWidget {
  final void Function({BuildContext ctx, String text}) submitComment;
  String currentUserProfileImage;

  CommentForm({
    this.submitComment,
  });

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  var _commentTextController = TextEditingController();

  bool _postEnabled = false;

  @override
  void dispose() {
    this._commentTextController.dispose();
    super.dispose();
  }

  void _showDialog(String title, String message, {bool success = true}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          title,
          style: TextStyle(color: success ? Colors.green : Colors.red),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'done',
              style: TextStyle(color: success ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment() {
    try {
      this.widget.submitComment(
            ctx: context,
            text: this._commentTextController.text,
          );
      this._showDialog(
          "Congratulations", "Successfully posted your commented!");
      setState(() {
        this._commentTextController.clear();
      });
    } catch (error) {
      var errorMessage = "Can't post comment at the moment!";
      this._showDialog("An Error Occured!", errorMessage, success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<UserProvider>(context).currentStaticUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            flex: 2,
            child: CircularProfileItem(
              imageUrl: currentUser.profileImageUrl,
              haveBorder: true,
              profileRadius: 20,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 7,
            child: TextField(
              controller: this._commentTextController,
              decoration: InputDecoration(
                focusColor: Colors.black,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: 'Add a comment...',
              ),
              onChanged: (value) => {
                if (value.trim().length > 0) {
                  setState(() {
                    this._postEnabled = true;
                  })
                } else {
                  setState(() {
                    this._postEnabled = false;
                  })
                }
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: FlatButton(
              onPressed: this._postEnabled
                  ? this._submitComment
                  : null,
              child: Text('Post'),
              textColor: Colors.blue,
              disabledTextColor: Colors.blue[100],
            ),
          ),
        ],
      ),
    );
  }
}
