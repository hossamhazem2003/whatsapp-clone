import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/data/reposotries/auth%20repo%20impl/auth_repo_impl.dart';
import 'package:whatsapp/domain/reposotries/auth%20repo/auth_repo.dart';
import 'package:whatsapp/ui/screens/auth%20screens/user_data_screen.dart';

class AuthVm extends ChangeNotifier {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String countryCode = '';
  String error = '';
  String number = '';
  bool isLoad = false;
  XFile? selectedImage;
  AuthRepo repo = AuthRepoImpl();

  updateCountry(Country? countryc) {
    countryCode = countryc!.phoneCode;
    notifyListeners();
  }

  void signInWithphoneNumber(Function errorStep, Function moveToScreen) {
    number = '+$countryCode${phoneController.text.trim()}';
    if (phoneController.text.isNotEmpty && countryCode.isNotEmpty) {
      print(
          'signInWithphoneNumber in authVM>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      isLoad = true;
      notifyListeners();
      try {
        repo.sentOtp(number, errorStep, moveToScreen);
      } catch (e) {
        error = e.toString();
        isLoad = false;
        notifyListeners();
      }
    } else {
      print('country is ${number}');
    }
  }



  void handleSubmit(String otpCode,BuildContext context) {
    if (otpCode.isNotEmpty) {
      repo.checkOTP(otpCode).then((value) {
        if (value == "Success") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserDataScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        }
      });
    }
  }

  addUserDataToFirestore() {
    number = '+$countryCode${phoneController.text.trim()}';
    if (nameController.text.isNotEmpty && selectedImage != null) {
      print('in authVm');
      isLoad = true;
      notifyListeners();
      try {
        repo.addUserDataToFirestore(
          nameController.text,
          number,
          selectedImage!,
          true,
        );
      } catch (e) {
        error = e.toString();
        isLoad = false;
        notifyListeners();
      }
    }
  }

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

  Future imageFromCamera() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      selectedImage = image;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
