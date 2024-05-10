// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/data/enums/message_enum.dart';
import 'package:whatsapp/domain/models/chat_contact_model.dart';
import 'package:whatsapp/domain/models/message_model.dart';
import 'package:whatsapp/domain/models/user_data_model.dart';
import 'package:whatsapp/domain/reposotries/chat_repo.dart';
import 'package:whatsapp/ui/widgets/error_snackBar.dart';

class ChatRepoImpl extends ChatRepo {
  @override
  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required bool isGroupChat}) async {
    try {
      var _firestore = FirebaseFirestore.instance;
      var timeSent = DateTime.now();
      UserDataModel? recieverUserData;
      UserDataModel senderUserData;

      print('is grouuuuuuuuuuuuuuuuuuuuuuuuuuuuuup is $isGroupChat');

      if (!isGroupChat) {
        var userDataMap =
            await _firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserDataModel.fromMap(userDataMap.data()!);
      }

      print(
          'is grouuuuuuuuuuuuuuuuuuuuuuuuuuuuuup is $isGroupChat after check');
      print(recieverUserId);

      var messageId = const Uuid().v1();

      var senderDataDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<String, dynamic>? senderDocs = senderDataDocs.data();
      senderUserData = UserDataModel(
        name: senderDocs!['user_name'],
        uid: senderDocs['user_id'],
        profilePic: senderDocs['url_image'],
        isOnline: senderDocs['user_state'],
        phoneNumber: senderDocs['user_phone'],
        groupId: List<String>.from(senderDocs['user_groups']),
      );

      saveDataToContactsSubcollection(senderUserData, recieverUserData, text,
          timeSent, recieverUserId, isGroupChat);

      saveMessageToMessageSubcollection(
          recieverUserId,
          text,
          timeSent,
          MessageEnum.text,
          messageId,
          recieverUserData?.name,
          senderUserData.name,
          isGroupChat);

      print('saveMessageToMessageSubcollection dooooooooone');
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }

  void saveDataToContactsSubcollection(
      UserDataModel senderUserData,
      UserDataModel? recieverUserData,
      String text,
      DateTime timeSent,
      String recieverUserId,
      bool isGroupChat) async {
    var _firestore = FirebaseFirestore.instance;

    if (isGroupChat) {
      await _firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      //save reciever_data_user to contacts subcollection in firestore
      var recieverChatContact = ChatContact(
          name: senderUserData.name,
          profilePic: senderUserData.profilePic,
          contactId: senderUserData.uid,
          timeSent: timeSent,
          lastMessage: text);
      _firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': recieverChatContact.name,
        'last_message': recieverChatContact.lastMessage,
        'id': recieverChatContact.contactId,
        'profile_pic': recieverChatContact.profilePic,
        'time_sent': recieverChatContact.timeSent,
      });

      //save sender_data_user to contacts subcollection in firestore
      var senderChatContact = ChatContact(
          name: recieverUserData!.name,
          profilePic: recieverUserData.profilePic,
          contactId: recieverUserData.uid,
          timeSent: timeSent,
          lastMessage: text);
      _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set({
        'name': senderChatContact.name,
        'last_message': senderChatContact.lastMessage,
        'id': senderChatContact.contactId,
        'profile_pic': senderChatContact.profilePic,
        'time_sent': senderChatContact.timeSent,
      });
    }
  }

  void saveMessageToMessageSubcollection(
      String recieverUserId,
      String text,
      DateTime timeSent,
      MessageEnum messageType,
      String messageId,
      String? recieverUserName,
      String senderUsername,
      bool isGroupChat) async {
    print('we start in saveMessageToMessageSubcollection');
    var _firestore = FirebaseFirestore.instance;

    print(
        'recieverUserId in saveMessageToMessageSubcollection $recieverUserId');

    var message = Message(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        recieverid: recieverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    if (isGroupChat) {
      print('we are in saveMessageToMessageSubcollection in group');
      // groups -> group id -> chat -> message
      await _firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      //save reciever_data_user_messages to contacts subcollection in firestore
      _firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      //save sender_data_user_messages to contacts subcollection in firestore
      _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  Future<UserDataModel> senderData() async {
    UserDataModel senderData;
    var senderDataDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? docs = senderDataDocs.data();
    senderData = UserDataModel(
      name: docs?['user_name'],
      uid: docs!['user_id'],
      profilePic: docs['url_image'],
      isOnline: docs['user_state'],
      phoneNumber: docs['user_phone'],
      groupId: List<String>.from(docs['user_groups']),
    );
    return senderData;
  }

  @override
  void sendFileMessage({
    required context,
    required file,
    required recieverUserId,
    required messageEnum,
    required isGroupChat,
  }) async {
    try {
      var _firestore = FirebaseFirestore.instance;
      var timeSent = DateTime.now();
      UserDataModel? recieverUserData;
      UserDataModel senderUserData;

      if (!isGroupChat) {
        var userDataMap =
            await _firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserDataModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      var userDataDocs =
          await _firestore.collection('users').doc(recieverUserId).get();
      Map<String, dynamic>? docs = userDataDocs.data();
      recieverUserData = UserDataModel(
        name: docs?['user_name'],
        uid: docs!['user_id'],
        profilePic: docs['url_image'],
        isOnline: docs['user_state'],
        phoneNumber: docs['user_phone'],
        groupId: List<String>.from(docs['user_groups']),
      );

      var senderDataDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<String, dynamic>? docsSender = senderDataDocs.data();
      senderUserData = UserDataModel(
        name: docsSender!['user_name'],
        uid: docsSender['user_id'],
        profilePic: docsSender['url_image'],
        isOnline: docsSender['user_state'],
        phoneNumber: docsSender['user_phone'],
        groupId: List<String>.from(docsSender['user_groups']),
      );

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('url_image')
          .child(
              "chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId");
      TaskSnapshot uploadTask = await storageRef.putFile(File(file.path));
      String imageUrl = await uploadTask.ref.getDownloadURL();

      String conntactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          conntactMsg = 'Photo';
          break;
        case MessageEnum.audio:
          conntactMsg = 'Audio';
          break;
        case MessageEnum.gif:
          conntactMsg = 'Gif';
          break;
        case MessageEnum.video:
          conntactMsg = 'Video';
          break;
        default:
          conntactMsg = 'Gif';
      }
      saveDataToContactsSubcollection(senderUserData, recieverUserData,
          conntactMsg, timeSent, recieverUserId, isGroupChat);

      saveMessageToMessageSubcollection(
          recieverUserId,
          imageUrl,
          timeSent,
          messageEnum,
          messageId,
          recieverUserData.name,
          senderUserData.name,
          isGroupChat);
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }
}
