import 'package:flutter/material.dart';

import '../models/feed.dart';

import '../screens/feed_detail_screen.dart';

class FeedGrid extends StatelessWidget {
  final List<Feed> feedList;
  final emptyGridMessage;

  FeedGrid({@required this.feedList, this.emptyGridMessage = 'No feeds currently',});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.feedList == null || this.feedList.length == 0
          ? Container(
            height: 200,
            width: 100,
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.camera_alt,size: 40,),
                    Text(this.emptyGridMessage),
                  ],
                ),
              ),
          )
          : GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: this.feedList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1 / 1,
              ),
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(FeedDetailScreen.routeName,
                      arguments: this.feedList[index].feedId);
                },
                child: Container(
                  key: ValueKey(this.feedList[index].feedId),
                  height: 60,
                  decoration: BoxDecoration(
                    //border: Border.all(width: 1,color: Colors.black54),
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.black54,
                      ],
                    ),
                  ),
                  child: Image.network(
                          this.feedList[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
    );
  }
}
