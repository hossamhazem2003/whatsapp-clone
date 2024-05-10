import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/data/reposotries/group_repo_impl.dart';
import 'package:whatsapp/domain/reposotries/group_repo.dart';

import '../../../data/reposotries/contact_repo_impl.dart';
import '../../../domain/reposotries/contact_repo.dart';

class GroupScreenVM extends ChangeNotifier {
  ContactRepo chatRepo = ContactRepoImpl();
  GroupRepo groupRepo = GroupRepoImpl();
  String error = '';
  bool isLoad = false;
  List<int> selectedContactsIndex = [];
  XFile? selectedImage;
  TextEditingController groupNameController = TextEditingController();

  Future<List<Contact>?> getcontacts() async {
    try {
      isLoad = true;
      notifyListeners();
      return await chatRepo.getContacts();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
    isLoad = true;
    notifyListeners();
    return null;
  }

  void createGroup(BuildContext context, List<Contact> selectedContact) {
    if (groupNameController.text.isNotEmpty) {
      groupRepo.createGroup(context, groupNameController.text.trim(),
          selectedImage!, selectedContact);
    } else {
      error = 'Please enter name for your group';
    }
    groupNameController.clear();
    Navigator.pop(context);
  }

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    notifyListeners();
  }

  Future imageFromGallery() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      selectedImage = image;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
