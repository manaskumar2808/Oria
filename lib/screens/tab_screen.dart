import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import './explore_screen.dart';
import './home_screen.dart';
import './user_profile_screen.dart';
import './feed_form_screen.dart';
import './search_screen.dart';

import '../widgets/circular_profile_item.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final _iconHeight = 30.00;
  final _iconWidth = 30.00;

  var _pageIndex = 0;
  var _page = [
    HomeScreen(),
    ExploreScreen(),
    FeedFormScreen(
      creatingNewFeed: true,
    ),
    SearchScreen(),
    UserProfileScreen(
      isCurrentUser: true,
    ),
  ];

  void _selectPage(int index) {
    setState(() {
      this._pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currentUser =
    //     Provider.of<UserProvider>(context).findByAuthId(this.widget.userId);

    return Scaffold(
      body: this._page[this._pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: this._pageIndex,
        onTap: this._selectPage,
        elevation: 5,
        selectedItemColor: Colors.black, //Theme.of(context).primaryColor,
        selectedFontSize: 20,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 20,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              height: this._iconHeight,
              width: this._iconWidth,
              child: Icon(Icons.home),
            ),
            title: Text('home'),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: this._iconHeight,
              width: this._iconWidth,
              child: Icon(Icons.explore),
            ),
            title: Text('explore'),
          ),
          BottomNavigationBarItem(
              icon: SizedBox(
                height: this._iconHeight,
                width: this._iconWidth,
                child: Icon(Icons.add_to_queue),
              ), 
              title: Text('post'),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: this._iconHeight,
              width: this._iconWidth,
              child: Icon(Icons.search),
            ),
            title: Text('search'),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: this._iconHeight,
              width: this._iconWidth,
              child: FutureBuilder(
                future: Provider.of<UserProvider>(context).currentUser,
                builder: (context, currentUserSnapshot) =>
                    currentUserSnapshot.connectionState == ConnectionState.waiting
                        ? CircularProfileItem(
                            imageUrl: null,
                            haveBorder: false,
                            profileRadius: 15,
                          )
                        : CircularProfileItem(
                            imageUrl: currentUserSnapshot.data.profileImageUrl,
                            haveBorder: false,
                            profileRadius: 15,
                          ),
              ),
            ),
            title: Text('user'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.account_circle),
          //   title: Text('user'),
          // ),
        ],
      ),
    );
  }
}
