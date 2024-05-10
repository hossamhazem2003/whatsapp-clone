import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/ui/screens/status_screen.dart/status_view.dart';
import 'package:whatsapp/ui/screens/status_screen.dart/status_vm.dart';

import '../../../domain/models/status_model.dart';
import '../../../utiliz/colors.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StatusVM statusVM = Provider.of(context);
    return Scaffold(
        body: FutureBuilder<List<Status>>(
      future: statusVM.repo.getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> StatusView(status: statusData)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 5),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );
          },
        );
      },
    ));
  }
}
