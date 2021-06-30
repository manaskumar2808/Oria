import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/follow_provider.dart';

import '../widgets/follow_list.dart';

class FollowScreen extends StatefulWidget {
  static const String routeName = '/follow';

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  String userName;

  @override
  void initState() {
    this._tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    this._tabController.dispose();
    super.dispose();
  }

  void _follow({String userId}) async {
    try {
      await Provider.of<FollowProvider>(context,listen: false).follow(followedId: userId);
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    setState(() {
      this._tabController.index = arguments['index'];
    });

    final userId = arguments['id'];
    final defaultBar = arguments['default'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Follow'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TabBar(
              controller: this._tabController,
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  text: 'followers',
                ),
                Tab(
                  text: 'following',
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - 150,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  FollowList(
                    type: 'follower',
                    follow: this._follow,
                    userId: userId,
                  ),
                  FollowList(
                    type: 'following',
                    follow: this._follow,
                    userId: userId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
