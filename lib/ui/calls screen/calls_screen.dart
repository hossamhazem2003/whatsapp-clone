import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/utiliz/colors.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('call').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Sonthing Wrong!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var docs = snapshot.data!.docs;
            log('lenth is ${docs.length}');
            return ListView.builder(
                itemCount: docs.length - 1,
                itemBuilder: (context, index) {
                  var data = docs[index].data();
                  return data['callerId'] !=
                          FirebaseAuth.instance.currentUser!.uid
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            style: ListTileStyle.drawer,
                            shape: Border.all(color: tabColor),
                            title: Text(data['callerName'],style: const TextStyle(fontSize: 25),),
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(data['callerPic']),
                              ),
                            ),
                          ),
                      ): Container();
                });
          }),
    );
  }
}
