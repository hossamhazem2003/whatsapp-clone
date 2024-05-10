import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

abstract class ContactRepo {
  Future<List<Contact>> getContacts();
  void selectContact(List<Contact> selectedContact, int index, BuildContext context);
}
