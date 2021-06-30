import 'package:flutter/material.dart';

import '../utilities/time.dart';

import '../widgets/circular_profile_item.dart';

class CommentItem extends StatefulWidget {
  final String text;
  final String commentorUserName;
  final String commentorProfileImageUrl;
  final String timestamp;

  CommentItem({
    this.text,
    this.commentorUserName,
    this.commentorProfileImageUrl,
    this.timestamp,
  });

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: CircularProfileItem(
              imageUrl: this.widget.commentorProfileImageUrl,
              haveBorder: true,
              profileRadius: 20,
            ),
          ),
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      text: this.widget.commentorUserName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan> [
                        TextSpan(
                          text: ' ${this.widget.text}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                      ]
                    ),
                    
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Text(
                  //       this.widget.commentorUserName,
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //     Text('  ${this.widget.text}'),
                  //   ],
                  // ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('${getTime(this.widget.timestamp)}${getAbbreviation(this.widget.timestamp)}', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
              ),
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
