// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/data/enums/message_enum.dart';
import 'package:whatsapp/data/reposotries/chat_repo_impl.dart';
import 'package:record/record.dart';
import '../../../domain/reposotries/chat_repo.dart';

class MessageScreenVm extends ChangeNotifier {
  TextEditingController messageController = TextEditingController();
  ScrollController messageScroleController = ScrollController();
  bool isSEnd = false;
  bool isShowEmojiContainer = false;
  bool isShowSendButton = false;
  FocusNode focusNode = FocusNode();
  ChatRepo repo = ChatRepoImpl();

  // record variables declare
  final recorder = AudioRecorder();
  String? audioFilePath;
  bool isRecording = false;
  final audioPlayer = AudioPlayer();
  String path = '';
  bool isPlay = false;

  void startRecording(BuildContext context) async {
    isRecording = true;
    notifyListeners();
    // Check and request permission if needed
    if (await recorder.hasPermission()) {
      // Get the directory for storing application files
      final directory = await getApplicationDocumentsDirectory();
      path = '${directory.path}/recording.m4a';
      const encoder = AudioEncoder.aacLc;
      const config = RecordConfig(encoder: encoder, numChannels: 1);
      recorder.start(config, path: path);
      notifyListeners();
    }
  }

  void stopRecording(
      BuildContext context, String recieverUserId, isGroupChat) async {
    isRecording = false;
    notifyListeners();
    await recorder.stop().then(
      (value) async {
        audioFilePath = value;
        repo.sendFileMessage(
            context: context,
            file: XFile(path),
            recieverUserId: recieverUserId,
            messageEnum: MessageEnum.audio,
            isGroupChat: isGroupChat);
        await audioPlayer.play(DeviceFileSource(value!));
        notifyListeners();
      },
    );

    recorder.dispose();
    audioFilePath = '';
    notifyListeners();
  }

  startAudioPlay(String path) async {
    isPlay = true;
    notifyListeners();
    await audioPlayer.play(UrlSource(path));
  }

  stopAudioPlay() async {
    isPlay = false;
    notifyListeners();
    await audioPlayer.stop();
  }

  changeIcon(String val) {
    if (val.isEmpty) {
      isSEnd = false;
      notifyListeners();
    } else {
      isSEnd = true;
      notifyListeners();
    }
  }

  void sendTextMessage(
      BuildContext context, String recieverUserId, bool isGroupChat) {
      repo.sendTextMessage(
          context: context,
          text: messageController.text,
          recieverUserId: recieverUserId,
          isGroupChat: isGroupChat);
    
    messageController.clear();
    isSEnd = false;
    notifyListeners();
  }

  Future imageFromCamera(
      BuildContext context, String recieverUserId, bool isGroupChat) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (image != null) {
        repo.sendFileMessage(
            context: context,
            file: image,
            recieverUserId: recieverUserId,
            messageEnum: MessageEnum.image,
            isGroupChat: isGroupChat);
      }

      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future imageFromgalary(
      BuildContext context, String recieverUserId, bool isGroupChat) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (image != null) {
        repo.sendFileMessage(
            context: context,
            file: image,
            recieverUserId: recieverUserId,
            messageEnum: MessageEnum.image,
            isGroupChat: isGroupChat);
      }

      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future vedioFromStorage(
      BuildContext context, String recieverUserId, bool isGroupChat) async {
    try {
      XFile? video = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      if (video != null) {
        repo.sendFileMessage(
            context: context,
            file: video,
            recieverUserId: recieverUserId,
            messageEnum: MessageEnum.video,
            isGroupChat: isGroupChat);
      }

      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void hideEmojiContainer() {
    isShowEmojiContainer = false;
    notifyListeners();
  }

  void showEmojiContainer() {
    isShowEmojiContainer = true;
    notifyListeners();
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
      isSEnd = false;
      notifyListeners();
    } else {
      hideKeyboard();
      showEmojiContainer();
      isSEnd = true;
      notifyListeners();
    }
  }

  void updaterecordAccordingToEmoji() {
    isSEnd = true;
    notifyListeners();
  }
}
