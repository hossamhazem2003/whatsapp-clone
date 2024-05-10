import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/messages%20screen/message_screen_vm.dart';
import 'package:whatsapp/ui/widgets/video_player.dart';
import 'package:whatsapp/utiliz/colors.dart';

import 'my_message_card.dart';
import 'sender_message_card.dart';

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  String uid;
  MessageScreenVm messageScreenVm;
  bool isGroup;
  ChatList({Key? key, required this.uid, required this.messageScreenVm, required this.isGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:isGroup == true? FirebaseFirestore.instance.collection('groups').doc(uid).collection('chats').snapshots() : FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chats')
            .doc(uid)
            .collection('messages')
            .orderBy('timeSent')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = snapshot.data!.docs;

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageScreenVm.messageScroleController.jumpTo(messageScreenVm
                .messageScroleController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageScreenVm.messageScroleController,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(document['timeSent']);
              String formattedDateTime = DateFormat('hh:mm a').format(dateTime);
              if (document['senderId'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return document['type'] == 'audio'
                    ? Container(
                        decoration: BoxDecoration(
                            color: messageColor,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(
                            bottom: 8,
                            top: 8,
                            right: 10,
                            left: MediaQuery.of(context).size.width * 0.60),
                        child: Consumer<MessageScreenVm>(
                          builder: (BuildContext context, MessageScreenVm value,
                                  _) =>
                              IconButton(
                                  onPressed: () {
                                    if (value.isPlay == false) {
                                      value.startAudioPlay(document['text']);
                                    } else {
                                      value.stopAudioPlay();
                                    }
                                  },
                                  icon: Icon(
                                    value.isPlay == true
                                        ? Icons.stop_circle_rounded
                                        : Icons.play_circle_fill,
                                    size: 50,
                                  )),
                        ),
                      )
                    : document['type'] == 'video'
                        ? Card(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.20,
                                right: 10,
                                top: 10,
                                bottom: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: VideoPlayerItem(
                                    videoUrl: document['text'])))
                        : document['type'] == 'image'
                            ? Card(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.35,
                                    right: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      document['text'],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.40,
                                      fit: BoxFit.fill,
                                    )))
                            : MyMessageCard(
                                message: document['text'],
                                date: formattedDateTime,
                              );
              }
              return document['type'] == 'audio'
                  ? Container(
                      decoration: BoxDecoration(
                          color: senderMessageColor,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(
                          left: 10,
                          top: 10,
                          bottom: 10,
                          right: MediaQuery.of(context).size.width * 0.60),
                      child: Consumer<MessageScreenVm>(
                        builder:
                            (BuildContext context, MessageScreenVm value, _) =>
                                IconButton(
                                    onPressed: () {
                                      if (value.isPlay == false) {
                                        value.startAudioPlay(document['text']);
                                      } else {
                                        value.stopAudioPlay();
                                      }
                                    },
                                    icon: Icon(
                                      value.isPlay == true
                                          ? Icons.stop_circle_rounded
                                          : Icons.play_circle_fill,
                                      size: 50,
                                    )),
                      ),
                    )
                  : document['type'] == 'video'
                      ? Card(
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.20,
                              left: 10,
                              top: 10,
                              bottom: 10),
                          child: VideoPlayerItem(videoUrl: document['text']))
                      : document['type'] == 'image'
                          ? Card(
                              margin: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.35,
                                  left: 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    document['text'],
                                    height: MediaQuery.of(context).size.height *
                                        0.40,
                                    fit: BoxFit.fill,
                                  )))
                          : SenderMessageCard(
                              message: document['text'],
                              date: formattedDateTime,
                            );
            },
          );
        });
  }
}
