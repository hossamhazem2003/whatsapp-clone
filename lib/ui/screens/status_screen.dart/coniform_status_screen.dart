import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/status_screen.dart/status_vm.dart';

import '../../../utiliz/colors.dart';
import '../home screen/home_screen.dart';

class ConfirmStatusScreen extends StatelessWidget {
  const ConfirmStatusScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StatusVM statusVM = Provider.of(context);
    return Scaffold(
      body: Center(
        child: statusVM.selectedImage == null
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.file(File(statusVM.selectedImage!.path)),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          statusVM.addStatus(context);
          if (statusVM.downloadDone == true) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Downloading...'),
                      ],
                    ),
                  );
                });
          }
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
