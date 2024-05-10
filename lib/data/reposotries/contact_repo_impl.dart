// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whatsapp/domain/models/user_data_model.dart';
import 'package:whatsapp/domain/reposotries/contact_repo.dart';
import 'package:whatsapp/ui/widgets/error_snackBar.dart';

import '../../ui/screens/messages screen/messages_screen.dart';

class ContactRepoImpl extends ContactRepo {
  @override
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return contacts;
  }

  @override
  void selectContact(selectedContact, index, context) async {
    try {
      var dataCollection =
          await FirebaseFirestore.instance.collection('users').get();
      bool isFound = false;
      for (var document in dataCollection.docs) {
        var docs = document.data();
        UserDataModel userData = UserDataModel(
          name: docs['user_name'],
          uid: docs['user_id'],
          profilePic: docs['url_image'],
          isOnline: docs['user_state'],
          phoneNumber: docs['user_phone'],
          groupId: List<String>.from(docs['user_groups']),
        );

        String selectedPhoneNum =
            selectedContact[index].phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              settings: RouteSettings(
                arguments: {
                  'name': userData.name,
                  'id': userData.uid,
                  'state': userData.isOnline
                },
              ),
              builder: (_) => MessagesScreen(),
            ),
          );
          break; // Optional: Exit the loop since a match has been found
        }
      }
      if (!isFound) {
        errorSnackBar(context, 'number not exist on this app');
      }
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }
}
