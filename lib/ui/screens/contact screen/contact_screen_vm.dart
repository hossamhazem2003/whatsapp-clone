import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp/data/reposotries/contact_repo_impl.dart';
import 'package:whatsapp/domain/reposotries/contact_repo.dart';

class ContactScreenVM extends ChangeNotifier {
  ContactRepo repo = ContactRepoImpl();
  String error = '';
  bool isLoad = false;

  Future<List<Contact>?> getcontacts() async {
    try {
      isLoad = true;
      notifyListeners();
      return await repo.getContacts();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
    isLoad = true;
    notifyListeners();
    return null;
  }

  selectContact(selectedContact, index, context) {
    try {
      repo.selectContact(selectedContact, index, context);
    } catch (e) {
      error = e.toString();
      print('errrrrrrrrrrrrrrrrrrrooooooooooooorrrrrrrrrrrrrrrr $error');
      notifyListeners();
    }
  }
}
