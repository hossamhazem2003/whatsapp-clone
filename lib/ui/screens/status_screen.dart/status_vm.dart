import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/data/reposotries/status_repo_imol.dart';
import 'package:whatsapp/domain/reposotries/status_repo.dart';

class StatusVM extends ChangeNotifier {
  XFile? selectedImage;
  bool downloadDone = false;
  StatusRepo repo = StatusRepoImpl();

  Future imageFromGallery() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      selectedImage = image;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void addStatus(BuildContext context) {
    repo.uploadStatus(statusImage: selectedImage!, context: context);
    log('uploaded Done');
    downloadDone = true;
    notifyListeners();
  }
}
