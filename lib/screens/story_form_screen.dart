import 'package:flutter/material.dart';

import '../widgets/story_form.dart';

class StoryFormScreen extends StatelessWidget {
  static const String routeName = '/story';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryForm(),
    );
  }
}
