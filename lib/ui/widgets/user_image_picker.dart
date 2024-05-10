// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/auth%20screens/auth_vm.dart';


class UserImagePicker extends StatelessWidget {
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
      builder: (context, value, child) {
        return Stack(
          children: [
            InkWell(
              onTap: value.imageFromGallery,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: value.selectedImage == null
                    ? const AssetImage('assets/images/no_image.jpg') as ImageProvider
                    : FileImage(File(value.selectedImage?.path ?? 'assets/images/no_image.jpg')),
                radius: 55,
              ),
            ),
            Positioned(
                bottom: 0,
                right: -10,
                child: IconButton(
                    onPressed: value.imageFromCamera,
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 30,
                    )))
          ],
        );
      },
    );
  }
}
