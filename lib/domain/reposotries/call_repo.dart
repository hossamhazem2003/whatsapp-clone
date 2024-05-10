import 'package:flutter/material.dart';


abstract class CallRepo {
  makeCall(
    BuildContext context,String receiverUid, String receiverName, String receiverProfilePic
  );
  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  );
}
