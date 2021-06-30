import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/story_provider.dart';

import '../screens/story_form_screen.dart';

import '../widgets/circular_profile_item.dart';

class StoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<StoryProvider>(context).stories,
        builder: (ctx, storiesSnapshot) {
          if (storiesSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 130,
            );
          }
          return Container(
            padding: const EdgeInsets.all(10),
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  FutureBuilder(
                    future: Provider.of<UserProvider>(context, listen: false)
                        .currentUser,
                    builder: (ctx, currentUserSnapshot) => currentUserSnapshot.connectionState == ConnectionState.waiting ?
                    Column(
                        children: <Widget>[
                          CircularProfileItem(
                            imageUrl: null,
                            profileRadius: 35,
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: Text('Add story'),
                          ),
                        ],
                      ) : GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(StoryFormScreen.routeName);
                      },
                      child: Column(
                        children: <Widget>[
                          CircularProfileItem(
                            imageUrl: currentUserSnapshot.data.profileImageUrl,
                            profileRadius: 35,
                            haveBorder: false,
                            haveAddPill: true,
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: Text('Add story'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: storiesSnapshot.data.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: <Widget>[
                            CircularProfileItem(
                              imageUrl:
                                  storiesSnapshot.data[index].storyTellerImageUrl,
                              profileRadius: 35,
                              whiteSpace: 3,
                              profileBorderWidth: 2,
                            ),
                            FittedBox(
                              fit: BoxFit.cover,
                              child: Text(storiesSnapshot
                                  .data[index].storyTellerUserName),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
          );
        });
  }
}
