import 'package:emoji_keyboard_flutter/emoji_keyboard_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/ui/screens/call%20screen/call_vm.dart';
import 'package:whatsapp/ui/screens/messages%20screen/message_screen_vm.dart';
import '../../../utiliz/colors.dart';
import '../../widgets/chat_list.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessageScreenVm messageScreenVm = Provider.of(context, listen: false);
    var args = ModalRoute.of(context)!.settings.arguments as Map;
    String name = args['name'];
    String uid = args['id'];
    bool isGroup = args['isGroupChat'] ?? false;
    String profilePic = args['profilePic'] ?? 'null';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                profilePic,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                isGroup == true
                    ? Container()
                    : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(fontSize: 15),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading...',
                              style: TextStyle(fontSize: 15),
                            );
                          }

                          var data = snapshot.data?.data();

                          return Text(
                            data!['user_state'] == true ? 'Online' : 'Offline',
                            style: const TextStyle(fontSize: 15),
                          );
                        },
                      )
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<CallVM>(context, listen: false)
                  .makeCall(context, name, uid, profilePic, isGroup);
            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(children: [
        Image.asset(
          'assets/images/backgroundImage.png',
          fit: BoxFit.fill,
          height: double.infinity,
        ),
        Column(
          children: [
            Expanded(
              child: ChatList(
                uid: uid,
                messageScreenVm: messageScreenVm,
                isGroup: isGroup,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions),
                    onPressed: messageScreenVm.toggleEmojiKeyboardContainer,
                  ),
                  Expanded(
                    child: TextFormField(
                      focusNode: messageScreenVm.focusNode,
                      controller: messageScreenVm.messageController,
                      validator: (value) {
                        if (value!.isEmpty) return 'Writhe something';
                        return null;
                      },
                      onChanged: (value) {
                        messageScreenVm.changeIcon(value);
                        print(messageScreenVm.isSEnd);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      messageScreenVm.imageFromCamera(context, uid, isGroup);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Choose an Option'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      messageScreenVm.imageFromgalary(
                                          context, uid, isGroup);
                                    },
                                    child: const Text(
                                      'Image from galary',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      messageScreenVm.vedioFromStorage(
                                          context, uid, isGroup);
                                    },
                                    child: const Text('Vedio from camera',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).then((value) {
                        if (value != null) {
                          print('You chose: $value');
                        }
                      });
                    },
                  ),
                  Consumer<MessageScreenVm>(
                    builder: (context, messageConsumerScreenVm, _) =>
                        CircleAvatar(
                      backgroundColor: tabColor,
                      child: Center(
                        child: messageConsumerScreenVm.isSEnd
                            ? IconButton(
                                onPressed: () {
                                  if (messageConsumerScreenVm
                                      .messageController.text.isNotEmpty) {
                                    messageConsumerScreenVm.sendTextMessage(
                                        context, uid, isGroup);
                                  }
                                },
                                icon: const Icon(Icons.send),
                              )
                            : messageConsumerScreenVm.isRecording == true
                                ? IconButton(
                                    onPressed: () {
                                      messageConsumerScreenVm.stopRecording(
                                          context, uid, isGroup);
                                    },
                                    icon: const Icon(Icons.stop_circle),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      messageConsumerScreenVm
                                          .startRecording(context);
                                    },
                                    icon: const Icon(Icons.mic),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            messageScreenVm.isShowEmojiContainer
                ? EmojiKeyboard(
                    emotionController: messageScreenVm.messageController,
                    emojiKeyboardHeight:
                        MediaQuery.of(context).size.height * 0.33,
                    showEmojiKeyboard: true,
                    darkMode: true)
                : const SizedBox(),
          ],
        ),
      ]),
    );
  }
}
