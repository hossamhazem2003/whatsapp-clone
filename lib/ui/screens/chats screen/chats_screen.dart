import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utiliz/colors.dart';
import '../messages screen/messages_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('groups').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  final groups = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final groupData = groups[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings: RouteSettings(arguments: {
                                          'name': groupData['name'],
                                          'id': groupData['groupId'],
                                          'isGroupChat': true,
                                          'profilePic': groupData['groupPic'],
                                        }),
                                        builder: (_) => const MessagesScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  groupData['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    groupData['lastMessage'],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    groupData['groupPic'],
                                  ),
                                  radius: 30,
                                ),
                                trailing:const Text(
                                  'Group',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: dividerColor, indent: 85),
                        ],
                      );
                    },
                  );
                }),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('chats')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    final documents = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        DateTime dateTime =
                            (document['time_sent'] as Timestamp).toDate();
                        String formattedDateTime =
                            DateFormat.MMMd().add_jm().format(dateTime);
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings: RouteSettings(arguments: {
                                          'name': document['name'],
                                          'id': document['id'],
                                          'profilePic': document['profile_pic'],
                                        }),
                                        builder: (_) => MessagesScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    document['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      document['last_message'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      document['profile_pic'],
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    formattedDateTime,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}






/*
════════ Exception caught by widgets library ═══════════════════════════════════
type 'int' is not a subtype of type 'DateTime'
*/