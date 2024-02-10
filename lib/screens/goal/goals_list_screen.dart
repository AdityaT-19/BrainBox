import 'package:brainbox/controllers/goals_list_controller.dart';
import 'package:brainbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalList extends StatelessWidget {
  GoalList({super.key});

  final _goalListController = Get.put<GoalListController>(GoalListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_goalListController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: _goalListController.goals.length,
          itemBuilder: (context, index) {
            if (_goalListController.goals.isEmpty) {
              return const Center(
                child: Text('No goals found'),
              );
            }
            return Card(
              child: ListTile(
                title: Text(_goalListController.goals[index].name),
                subtitle: Text(_goalListController.goals[index].description),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GOALINFO,
                    arguments: _goalListController.goals[index],
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
