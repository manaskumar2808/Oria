import 'package:flutter/material.dart';

import '../widgets/feed_form.dart';

class FeedFormScreen extends StatelessWidget {
  static const String routeName = '/feed-form';

  bool creatingNewFeed;

  FeedFormScreen({
    this.creatingNewFeed = false,
  });

  @override
  Widget build(BuildContext context) {
    String feedId = '';
    String location = '';
    String description = '';
    String imageUrl = '';
    bool isUpdating = true;

    if (!this.creatingNewFeed) {
      final arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      feedId = arguments['feedId'];
      location = arguments['location'];
      description = arguments['description'];
      imageUrl = arguments['imageUrl'];
      isUpdating = arguments['isUpdating'];
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Post Form'),
        ),
        body: creatingNewFeed
            ? FeedForm()
            : FeedForm(
                feedId: feedId,
                location: location,
                description: description,
                imageUrl: imageUrl,
                isUpdating: isUpdating,
              )
      );
  }
}
