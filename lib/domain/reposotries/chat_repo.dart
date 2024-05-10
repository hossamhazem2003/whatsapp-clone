import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/data/enums/message_enum.dart';

abstract class ChatRepo {
  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required bool isGroupChat,
  });

  void sendFileMessage({
    required BuildContext context,
    required XFile file,
    required String recieverUserId,
    required MessageEnum messageEnum,
    required bool isGroupChat
  });
}
