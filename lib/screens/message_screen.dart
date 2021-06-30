import 'package:flutter/material.dart';

import '../widgets/contact_list.dart';
import '../widgets/received_message_request_list.dart';
import '../widgets/sent_message_request_list.dart';

class MessageScreen extends StatefulWidget {
  static const String routeName = '/message';

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    this._tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    this._tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Messages'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TabBar(
              controller: this._tabController,
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  text: 'Contacts',
                ),
                Tab(
                  text: 'Send',
                ),
                Tab(
                  text: 'Requests',
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - 140,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  ContactList(),
                  SentMessageRequestList(),
                  ReceivedMessageRequestList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
