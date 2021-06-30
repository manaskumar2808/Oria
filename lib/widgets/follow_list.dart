import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';
import '../providers/user_provider.dart';

import '../widgets/circular_loader.dart';
import '../widgets/follow_item.dart';

class FollowList extends StatelessWidget {
  String type;
  String userId;
  final void Function({String userId}) follow;

  FollowList({
    this.userId,
    this.type,
    this.follow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: this.type == 'follower'
            ? FutureBuilder(
                future: Provider.of<FollowProvider>(context, listen: false)
                    .userFollowers(this.userId),
                builder: (ctx, followerSnapshot) => followerSnapshot
                            .connectionState ==
                        ConnectionState.waiting
                    ? Center(
                        child: CircularLoader(
                          thickness: 1,
                        ),
                      )
                    : ListView.builder(
                        itemCount: followerSnapshot.data.length,
                        itemBuilder: (context, index) => FutureBuilder(
                          future:
                              Provider.of<UserProvider>(context, listen: false)
                                  .findById(
                                      followerSnapshot.data[index].followerId),
                          builder: (ctx, followerUserSnapshot) =>
                              followerUserSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Center(
                                      child: CircularLoader(
                                        thickness: 1,
                                        diameter: 40,
                                      ),
                                    )
                                  : FutureBuilder(
                                      future: Provider.of<FollowProvider>(
                                              context,
                                              listen: false)
                                          .isFollowing(followerSnapshot
                                              .data[index].followerId),
                                      builder: (ctx, isFollowingSnapshot) =>
                                          isFollowingSnapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? FollowItem(
                                                  isFollowing: null,
                                                  userId: followerUserSnapshot
                                                      .data.userId,
                                                  userName: followerUserSnapshot
                                                      .data.userName,
                                                  profileImageUrl:
                                                      followerUserSnapshot
                                                          .data.profileImageUrl,
                                                  follow: this.follow,
                                                )
                                              : FollowItem(
                                                  isFollowing:
                                                      isFollowingSnapshot.data,
                                                  userId: followerUserSnapshot
                                                      .data.userId,
                                                  userName: followerUserSnapshot
                                                      .data.userName,
                                                  profileImageUrl:
                                                      followerUserSnapshot
                                                          .data.profileImageUrl,
                                                  follow: this.follow,
                                                ),
                                    ),
                        ),
                      ),
              )
            : FutureBuilder(
                future: Provider.of<FollowProvider>(context, listen: false)
                    .userFolloweds(this.userId),
                builder: (context, followedSnapshot) => followedSnapshot
                            .connectionState ==
                        ConnectionState.waiting
                    ? Center(
                        child: CircularLoader(
                          thickness: 1,
                        ),
                      )
                    : ListView.builder(
                        itemCount: followedSnapshot.data.length,
                        itemBuilder: (context, index) => FutureBuilder(
                            future: Provider.of<UserProvider>(context,
                                    listen: false).findById(followedSnapshot.data[index].followedId),
                            builder: (ctx, followedUserSnapshot) =>
                                followedUserSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Center(
                                        child: CircularLoader(
                                          thickness: 1,
                                          diameter: 40,
                                        ),
                                      )
                                    : FutureBuilder(
                                        future: Provider.of<FollowProvider>(
                                                context,
                                                listen: false)
                                            .isFollowing(followedSnapshot
                                                .data[index].followedId),
                                        builder: (ctx, isFollowingSnapshot) =>
                                            isFollowingSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting
                                                ? FollowItem(
                                                    isFollowing: null,
                                                    userId: followedUserSnapshot
                                                        .data.userId,
                                                    userName:
                                                        followedUserSnapshot
                                                            .data.userName,
                                                    profileImageUrl:
                                                        followedUserSnapshot
                                                            .data
                                                            .profileImageUrl,
                                                    follow: this.follow,
                                                  )
                                                : FollowItem(
                                                    isFollowing:
                                                        isFollowingSnapshot
                                                            .data,
                                                    userId: followedUserSnapshot
                                                        .data.userId,
                                                    userName:
                                                        followedUserSnapshot
                                                            .data.userName,
                                                    profileImageUrl:
                                                        followedUserSnapshot
                                                            .data
                                                            .profileImageUrl,
                                                    follow: this.follow,
                                                  ),
                                      )),
                      ),
              ));
  }
}
