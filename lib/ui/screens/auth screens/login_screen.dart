import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/auth%20screens/auth_vm.dart';
import 'package:whatsapp/ui/screens/auth%20screens/otp_screen.dart';
import 'package:whatsapp/utiliz/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVm authVm = Provider.of(context);
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Your phone number',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25),
            width: double.infinity,
            child: const Text(
              'Whatsapp will need to verify your phone number.',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: () {
                showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: authVm.updateCountry);
              },
              child: const Text('Pick country code')),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                '+ ${authVm.countryCode}',
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: TextFormField(
                  controller: authVm.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 30,
              )
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              authVm.signInWithphoneNumber(
                  () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Error in sending OTP",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      )),
                  () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => OTPScreen())));
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => tabColor)),
            child: authVm.isLoad == true
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : authVm.error.isNotEmpty
                    ? Text(authVm.error)
                    : const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
          ),
        ],
      ),
    );
  }
}
