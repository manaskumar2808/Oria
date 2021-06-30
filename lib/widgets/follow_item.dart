import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../widgets/circular_loader.dart';
import '../widgets/circular_profile_item.dart';

class FollowItem extends StatefulWidget {
  String userId;
  String userName;
  String profileImageUrl;
  bool isFollowing;
  final void Function({String userId}) follow;

  FollowItem({
    this.isFollowing,
    this.userId,
    this.userName,
    this.profileImageUrl,
    this.follow,
  });

  @override
  _FollowItemState createState() => _FollowItemState();
}

class _FollowItemState extends State<FollowItem> {
  void _followUser() {
    this.widget.follow(userId: this.widget.userId);
    setState(() {
      this.widget.isFollowing = !this.widget.isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Provider.of<UserProvider>(context).currentStaticUser.userId;

    return Container(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: CircularProfileItem(
          imageUrl: this.widget.profileImageUrl,
          haveBorder: false,
          profileRadius: 25,
        ),
        title: Text(this.widget.userName),
        trailing: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
          onPressed: currentUserId == this.widget.userId ? null : this._followUser,
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
          color: Colors.blue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
