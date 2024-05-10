

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';

abstract class GroupRepo {
  void createGroup(BuildContext context, String name, XFile profilePic,
      List<Contact> selectedContact);
}
