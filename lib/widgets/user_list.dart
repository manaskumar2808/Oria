import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/follow_provider.dart';

import '../widgets/circular_loader.dart';
import '../widgets/user_card.dart';

class UserList extends StatelessWidget {
  final void Function({BuildContext context,String userId}) follow;

  UserList({
    this.follow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: Provider.of<UserProvider>(context).users,
        builder: (context, usersSnapshot) => usersSnapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularLoader(
                  thickness: 1,
                  diameter: 50,
                ),
              )
            : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: usersSnapshot.data.length,
                  itemBuilder: (ctx, index) => FutureBuilder(
                    future: Provider.of<FollowProvider>(context).isFollowing(usersSnapshot.data[index].userId),
                    builder: (ctx,isFollowingSnapshot) => isFollowingSnapshot.connectionState == ConnectionState.waiting ? 
                    UserCard(
                      userId: usersSnapshot.data[index].userId,
                      userName: usersSnapshot.data[index].userName,
                      profileImageUrl: usersSnapshot.data[index].profileImageUrl,
                      isFollowing: null,
                      follow: this.follow,
                    ) : UserCard(
                      userId: usersSnapshot.data[index].userId,
                      userName: usersSnapshot.data[index].userName,
                      profileImageUrl: usersSnapshot.data[index].profileImageUrl,
                      isFollowing: isFollowingSnapshot.data,
                      follow: this.follow,
                    ),
                  ),
                ),
            ),
    );
  }
}
