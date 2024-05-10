// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/domain/models/call_model.dart';
import 'package:whatsapp/domain/reposotries/call_repo.dart';
import 'package:whatsapp/ui/widgets/error_snackBar.dart';

import '../../domain/models/user_data_model.dart';
import '../../ui/screens/call screen/call_screen.dart';

class CallRepoImpl extends CallRepo {
  final firestore = FirebaseFirestore.instance;

  @override
  makeCall(context, receiverUid, receiverName, receiverProfilePic) async {
    try {
      String callId = const Uuid().v1();

      var userDataMap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      UserDataModel senderUserData = UserDataModel.fromMap(userDataMap.data()!);

      Call senderCallData = Call(
        callerId: FirebaseAuth.instance.currentUser!.uid,
        callerName: senderUserData.name,
        callerPic: senderUserData.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
      );

      var recieverDataMap = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .get();
      UserDataModel revieverUserData =
          UserDataModel.fromMap(recieverDataMap.data()!);

      Call recieverCallData = Call(
        callerId: FirebaseAuth.instance.currentUser!.uid,
        callerName: revieverUserData.name,
        callerPic: revieverUserData.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
      );

      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(recieverCallData.toMap());

      log('add data of calling to firebase fire store');

      Future.delayed(const Duration(seconds: 1), () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
              channelId: senderCallData.callId,
              call: senderCallData,
              isGroupChat: false,
            ),
          ),
        );
      });
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }

  @override
  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }
}
