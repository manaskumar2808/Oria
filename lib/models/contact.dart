import 'package:flutter/foundation.dart';

class Contact {
  final String contactId;
  final String name;
  final String imageUrl;
  final DateTime createdTimestamp;

  Contact({
    @required this.contactId,
    @required this.name,
    this.imageUrl,
    @required this.createdTimestamp,
  });

}
