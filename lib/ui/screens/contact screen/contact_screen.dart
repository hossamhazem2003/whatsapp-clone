import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/contact%20screen/contact_screen_vm.dart';
import 'package:whatsapp/utiliz/colors.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    ContactScreenVM contactScreenVM = Provider.of<ContactScreenVM>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Screen'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: contactScreenVM.repo.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: tabColor),
            );
          }
          if (snapshot.hasError) {
            return Text(contactScreenVM.error);
          }
          if (snapshot.hasData) {
            List<Contact> contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    contactScreenVM.selectContact(
                        contacts,
                        index,
                        context
                    );
                  },
                  child: ListTile(
                    title: Text(contacts[index].displayName),
                    leading: contacts[index].photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage:
                                MemoryImage(contacts[index].photo!),
                            radius: 30,
                          ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
