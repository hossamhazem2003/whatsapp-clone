import 'package:flutter/material.dart';
import 'package:whatsapp/ui/screens/auth%20screens/login_screen.dart';

import '../../utiliz/colors.dart';
import '../widgets/custom_button.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Welcome to WhatsApp',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height / 9),
              Image.asset(
                'assets/images/bg.png',
                height: 340,
                width: 340,
                color: tabColor,
              ),
              SizedBox(height: size.height / 9),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  text: 'AGREE AND CONTINUE',
                  onPressed: () => navigateToLoginScreen(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}