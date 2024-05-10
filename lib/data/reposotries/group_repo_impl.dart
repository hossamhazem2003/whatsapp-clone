// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/domain/reposotries/group_repo.dart';
import 'package:whatsapp/ui/widgets/error_snackBar.dart';

import '../../domain/models/group_model.dart';

class GroupRepoImpl extends GroupRepo {
  @override
  void createGroup(context, name, profilePic, selectedContact) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContact[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('url_image')
          .child("groups/$groupId");
      TaskSnapshot uploadTask = await storageRef.putFile(File(profilePic.path));
      String imageUrl = await uploadTask.ref.getDownloadURL();
      Group group = Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: imageUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }
}
