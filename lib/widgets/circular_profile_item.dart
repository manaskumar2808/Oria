import 'package:flutter/material.dart';

class CircularProfileItem extends StatefulWidget {
  final String imageUrl;
  final double profileRadius;
  final double whiteSpace;
  final double profileMargin;
  final double profileBorderWidth;
  final Color profileBorderColor;
  final bool haveBorder;
  final bool haveAddPill;

  CircularProfileItem({
    @required this.imageUrl,
    this.profileRadius = 20,
    this.profileMargin = 5,
    this.whiteSpace = 2,
    this.profileBorderWidth = 1,
    this.profileBorderColor = Colors.black,
    this.haveBorder = true,
    this.haveAddPill = false,
  });

  @override
  _CircularProfileItemState createState() => _CircularProfileItemState();
}

class _CircularProfileItemState extends State<CircularProfileItem> {
  @override
  Widget build(BuildContext context) {
    return this.widget.haveBorder
        ? Container(
            padding: EdgeInsets.all(this.widget.whiteSpace),
            decoration: BoxDecoration(
              border: Border.all(
                  width: this.widget.profileBorderWidth,
                  color: this.widget.profileBorderColor),
              borderRadius: BorderRadius.circular(100),
            ),
            margin: EdgeInsets.all(this.widget.profileMargin),
            child: this.widget.imageUrl == null || this.widget.imageUrl.isEmpty
                ? Icon(Icons.account_circle,
                    size: this.widget.profileRadius * 2, color: Colors.grey)
                : CircleAvatar(
                    radius: this.widget.profileRadius,
                    backgroundImage: NetworkImage(this.widget.imageUrl),
                    backgroundColor: Colors.black38,
                  ))
        : (this.widget.imageUrl == null || this.widget.imageUrl.isEmpty
            ? Icon(
                Icons.account_circle,
                size: this.widget.profileRadius * 2,
                color: Colors.grey,
              )
            : 
              CircleAvatar(
                radius: this.widget.profileRadius,
                backgroundImage: NetworkImage(this.widget.imageUrl),
                backgroundColor: Colors.black38,
              )
          );
  }
}
