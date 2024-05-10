import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/auth%20screens/auth_vm.dart';
import 'package:whatsapp/ui/screens/home%20screen/home_screen.dart';
import 'package:whatsapp/ui/widgets/custom_txtfield.dart';
import 'package:whatsapp/ui/widgets/user_image_picker.dart';
import 'package:whatsapp/utiliz/colors.dart';

class UserDataScreen extends StatelessWidget {
  const UserDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVm authVm = Provider.of(context);
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      print('FirebaseAuth.instance.currentUser.uid is null');
    }
    print(
        'FirebaseAuth.instance.currentUser.uid is ${FirebaseAuth.instance.currentUser!.uid}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User Data'),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const UserImagePicker(),
            const SizedBox(
              height: 20,
            ),
            customTextField(
              'enter your name',
              authVm.nameController, IconButton(
                      onPressed: () {
                        authVm.addUserDataToFirestore();
                        if (authVm.error.isEmpty) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => HomeScreen()));
                        }
                      },
                      icon: Icon(Icons.done)),
            ),
          ],
        ),
      ),
    );
  }
}
