import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/auth%20screens/auth_vm.dart';
import 'package:whatsapp/ui/screens/call%20screen/call_vm.dart';
import 'package:whatsapp/ui/screens/contact%20screen/contact_screen_vm.dart';
import 'package:whatsapp/ui/screens/home%20screen/home_screen.dart';
import 'package:whatsapp/ui/screens/home%20screen/home_screen_vm.dart';
import 'package:whatsapp/ui/screens/introductry_screen.dart';
import 'package:whatsapp/ui/screens/messages%20screen/message_screen_vm.dart';
import 'package:whatsapp/ui/screens/status_screen.dart/status_vm.dart';
import 'package:whatsapp/utiliz/colors.dart';
import 'ui/screens/create group screen/group_screen_vm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class AppLifecycleStateNotifier with WidgetsBindingObserver, ChangeNotifier {
  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  AppLifecycleState get appLifecycleState => _appLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    _appLifecycleState = state;
    switch (state) {
      case AppLifecycleState.resumed:
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'isOnline': true,
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'isOnline': false,
        });
        break;
      default:
        print('Applife sychel error here');
    }
    notifyListeners();
  }

  void setup() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLifecycleStateNotifier = AppLifecycleStateNotifier();
    appLifecycleStateNotifier.setup();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthVm()),
        ChangeNotifierProvider(create: (_) => ContactScreenVM()),
        ChangeNotifierProvider(create: (_) => MessageScreenVm()),
        ChangeNotifierProvider(create: (_)=> HomeScreenVM()),
        ChangeNotifierProvider(create: (_)=> StatusVM()),
        ChangeNotifierProvider(create: (_)=> GroupScreenVM()),
        ChangeNotifierProvider(create: (_)=> CallVM()),
        ChangeNotifierProvider.value(value: appLifecycleStateNotifier),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp',
        theme:
            ThemeData.dark().copyWith(scaffoldBackgroundColor: backgroundColor),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const IntroScreen();
          },
        ),
      ),
    );
  }
}

/*
StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const IntroScreen();
          },
        ),
*/
