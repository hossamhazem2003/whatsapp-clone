import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp/domain/models/user_data_model.dart';
import 'package:whatsapp/domain/reposotries/auth%20repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String verifyId = "";
  // to sent and otp to user
  @override
  Future sentOtp(
    number,
    errorStep,
    moveToScreen,
  ) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        moveToScreen();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  // verify the otp code and login
  @override
  Future checkOTP(userOTP) async {
    final cred = PhoneAuthProvider.credential(
        verificationId: verifyId, smsCode: userOTP);

    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // to logout the user
  static Future logout() async {
    await _firebaseAuth.signOut();
  }

  // check whether the user is logged in or not
  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  @override
  Future<void> addUserDataToFirestore(
      name, phoneNumber, selectedImage, isOnline) async {
    final auth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      print('Start in addUserDataToFirestore +++++++++++++++');
      if (auth.currentUser != null) {
        // Check if currentUser is not null
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('url_image')
            .child("profilePic/${auth.currentUser!.uid}.jpg");
        TaskSnapshot uploadTask =
            await storageRef.putFile(File(selectedImage.path));
        String imageUrl = await uploadTask.ref.getDownloadURL();
        UserDataModel userModel = UserDataModel(
            name: name,
            uid: auth.currentUser!.uid,
            profilePic: imageUrl,
            isOnline: isOnline,
            phoneNumber: auth.currentUser!.phoneNumber ?? phoneNumber,
            groupId: []);
        await users
            .doc(auth.currentUser!.uid)
            .set({
              'user_id': userModel.uid,
              'user_name': userModel.name,
              'url_image': userModel.profilePic,
              'user_phone': userModel.phoneNumber,
              'user_state': userModel.isOnline,
              'user_groups': userModel.groupId
            })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      } else {
        print('No authenticated user found.');
        // Handle the case when there's no authenticated user
      }
    } on FirebaseAuthException catch (e) {
      print('error is $e');
    }
  }

  void setUserState(bool isOnline) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }
}
