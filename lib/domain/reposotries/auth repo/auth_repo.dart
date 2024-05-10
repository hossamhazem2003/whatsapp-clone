import 'package:image_picker/image_picker.dart';

abstract class AuthRepo {
  Future sentOtp(
      String number,Function errorStep ,Function moveToScreen);
  Future checkOTP(String userOTP);
  Future<void> addUserDataToFirestore(
      String name,String phoneNumber,XFile selectedImage, bool isOnline);
}
