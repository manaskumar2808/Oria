import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contact_provider.dart';

import '../widgets/circular_loader.dart';
import 'contact_item.dart';

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Provider.of<ContactProvider>(context,listen: false).contacts,
        builder: (context, contactSnapshot) => contactSnapshot.connectionState == ConnectionState.waiting ? 
        Center(
          child: CircularLoader(
            thickness: 1,
          ),
        ) : 
        contactSnapshot.data.length == 0 ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.supervisor_account,size: 80,),
              Text('No Contacts Yet',style: TextStyle(fontSize: 25),),
            ],
          ),
        ) : ListView.builder(
          itemCount: contactSnapshot.data.length,
          itemBuilder: (context, index) => ContactItem(
            contactId: contactSnapshot.data[index].contactId,
            name: contactSnapshot.data[index].name,
            imageUrl: contactSnapshot.data[index].imageUrl,
          )
        ),
      ),
    );
  }
}