// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/domain/models/user_data_model.dart';
import 'package:whatsapp/domain/reposotries/status_repo.dart';
import 'package:whatsapp/ui/widgets/error_snackBar.dart';

import '../../domain/models/status_model.dart';

class StatusRepoImpl extends StatusRepo {
  @override
  void uploadStatus({required statusImage, required context}) async {
    try {
      var statusId = const Uuid().v1();
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('url_image')
          .child("status/$statusId$uid");
      TaskSnapshot uploadTask =
          await storageRef.putFile(File(statusImage.path));
      String imageUrl = await uploadTask.ref.getDownloadURL();
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await FirebaseFirestore.instance
            .collection('users')
            .where(
              'user_phone',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserDataModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await FirebaseFirestore.instance
          .collection('status')
          .where(
            'uid',
            isEqualTo: uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await FirebaseFirestore.instance
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }
      log('before get user data');
      var document =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      var docs = document.data() as Map;
      Status status = Status(
        uid: uid,
        username: docs['user_name'],
        phoneNumber: docs['user_phone'],
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: docs['url_image'],
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );
      log('after get user data');
      await FirebaseFirestore.instance
          .collection('status')
          .doc(statusId)
          .set(status.toMap());
      log('status added to firebase');
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }

  @override
  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await FirebaseFirestore.instance
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch,
            )
            .get();
        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee
              .contains(FirebaseAuth.instance.currentUser!.uid)) {
            statusData.add(tempStatus);
            log('user name ${tempStatus.username}');
          }
        }
      }
    } catch (e) {
      log('error iss ${e.toString()}');
      errorSnackBar(context, e.toString());
    }
    return statusData;
  }
}
