import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/create%20group%20screen/group_screen_vm.dart';

import '../../../utiliz/colors.dart';
import '../../widgets/select_contact_group.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GroupScreenVM groupScreenVM = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                groupScreenVM.selectedImage == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/no_image.jpg',
                        ),
                        radius: 64,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(
                          File(groupScreenVM.selectedImage!.path),
                        ),
                        radius: 64,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: groupScreenVM.imageFromGallery,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupScreenVM.groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SelectContactsGroup(groupScreenVM: groupScreenVM),
          ],
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: groupScreenVM.getcontacts(),
        builder: (context, snapshot) {
          return FloatingActionButton(
            onPressed: () {
              groupScreenVM.createGroup(context, snapshot.data!);
            },
            backgroundColor: tabColor,
            child: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          );
        }
      ),
    );
  }
}
