import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/auth%20screens/auth_vm.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVm authVm = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Verifying your number')),
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              child: const Text(
                'we have sent an SMS with a code',
                textAlign: TextAlign.center,
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.23,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  hintText: '- - - - - -', hintStyle: TextStyle(fontSize: 25)),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                if (value.length == 6) {
                  authVm.handleSubmit(value, context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
