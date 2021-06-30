import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../widgets/circular_loader.dart';
import '../widgets/circular_profile_item.dart';

class UserCard extends StatefulWidget {
  String userId;
  String userName;
  String profileImageUrl;
  bool isFollowing;
  final void Function({BuildContext context, String userId}) follow;

  UserCard({
    this.userId,
    this.userName,
    this.profileImageUrl,
    this.isFollowing,
    this.follow,
  });

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  void _follow() {
    this.widget.follow(context: context, userId: this.widget.userId);
    setState(() {
      this.widget.isFollowing = !this.widget.isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Provider.of<UserProvider>(context).currentStaticUser.userId;

    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProfileItem(
              imageUrl: this.widget.profileImageUrl,
              haveBorder: false,
              profileRadius: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(this.widget.userName),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: currentUserId == this.widget.userId ? null : this._follow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Colors.blue,
              child: this.widget.isFollowing == null
                  ? CircularLoader(
                      thickness: 1,
                      color: Colors.white,
                      diameter: 20,
                    )
                  : Text(
                      this.widget.isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(color: Colors.white),
                    ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
