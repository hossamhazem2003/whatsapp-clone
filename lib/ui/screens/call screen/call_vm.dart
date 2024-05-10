// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:whatsapp/data/reposotries/call_repo_impl.dart';
import 'package:whatsapp/domain/reposotries/call_repo.dart';

class CallVM extends ChangeNotifier {
  CallRepo repo = CallRepoImpl();

  void makeCall(BuildContext context, String receiverName, String receiverUid
      ,String receiverProfilePic, bool isGroupChat) {
        repo.makeCall(context, receiverUid, receiverName, receiverProfilePic);
    }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    repo.endCall(callerId, receiverId, context);
  }
}
