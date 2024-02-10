import 'package:brainbox/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfo extends StatelessWidget {
  final user = Get.find<AuthController>().user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: Obx(() {
        if (user.value.gids.isEmpty) {
          return const Center(
            child: Text('No groups found'),
          );
        }
        return ListView.builder(
          itemCount: user.value.gids.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(user.value.gids[index].name),
                subtitle: Text(user.value.gids[index].gid),
              ),
            );
          },
        );
      }),
    );
  }
}
