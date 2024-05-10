import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/chats%20screen/chats_screen.dart';
import 'package:whatsapp/ui/screens/contact%20screen/contact_screen.dart';
import 'package:whatsapp/ui/screens/create%20group%20screen/create_group_screen.dart';
import 'package:whatsapp/ui/screens/home%20screen/home_screen_vm.dart';
import 'package:whatsapp/ui/screens/status_screen.dart/status_screen.dart';
import 'package:whatsapp/ui/screens/status_screen.dart/status_vm.dart';

import '../../../utiliz/colors.dart';
import '../../calls screen/calls_screen.dart';
import '../status_screen.dart/coniform_status_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenVM homeScreenVM = Provider.of(context);
    // التنقل بين الصفحان
    const List _pages = [
      ChatsScreen(),
      StatusScreen(),
      CallsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tabColor,
        centerTitle: false,
        title: const Text(
          'WhatsApp',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton(
              color: Colors.black,
              icon: const Icon(Icons.more_vert,color: Colors.white,),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text(
                        'Create Group',
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> CreateGroupScreen()));
                      },
                    )
                  ])
        ],
      ),
      body: _pages[homeScreenVM.selectedScreen],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (homeScreenVM.selectedScreen == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ContactScreen()));
          } else if (homeScreenVM.selectedScreen == 1) {
            Provider.of<StatusVM>(context, listen: false).imageFromGallery();
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ConfirmStatusScreen()));
          }
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.comment,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: backgroundColor),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Calls',
            ),
          ],
          currentIndex: homeScreenVM.selectedScreen,
          selectedItemColor: tabColor,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            homeScreenVM.changeScreen(index);
          },
        ),
      ),
    );
  }
}
