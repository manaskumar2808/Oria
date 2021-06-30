import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';

import '../widgets/user_list.dart';

class SearchScreen extends StatelessWidget {


  void _follow({BuildContext context,String userId}) async {
    try {
      await Provider.of<FollowProvider>(context,listen: false).follow(followedId: userId);
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('   Search Users'),
                  Text('See all  ',style: TextStyle(color: Colors.blue),),
                ],
              ),
            ),
            UserList(follow: this._follow),
          ],
        ),
      ),
    );
  }
}