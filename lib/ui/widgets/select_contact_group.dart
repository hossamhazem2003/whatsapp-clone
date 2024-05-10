import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../screens/create group screen/group_screen_vm.dart';

// ignore: must_be_immutable
class SelectContactsGroup extends StatelessWidget {
  GroupScreenVM groupScreenVM;
  SelectContactsGroup({Key? key, required this.groupScreenVM})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: groupScreenVM.getcontacts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(groupScreenVM.error),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white,),);
          }
          List<Contact> contactList = snapshot.data!;
          return Expanded(
            child: ListView.builder(
                itemCount: contactList.length, ////
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => groupScreenVM.selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: groupScreenVM.selectedContactsIndex.contains(index)
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.done),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
