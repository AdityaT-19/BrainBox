import 'package:brainbox/models/goal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GoalInfo extends StatelessWidget {
  const GoalInfo({Key? key, required this.goal}) : super(key: key);
  final Goal goal;

  String _getReccuerence() {
    return goal.recurrence == Recurrence.daily
        ? 'Daily'
        : goal.recurrence == Recurrence.weekly
            ? 'Weekly'
            : goal.recurrence == Recurrence.fortnightly
                ? '15 days once'
                : 'None';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal.name),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Name'),
            subtitle: Text(goal.name),
          ),
          ListTile(
            title: const Text('Description'),
            subtitle: Text(goal.description),
          ),
          ListTile(
            title: const Text('Created Date'),
            subtitle: Text(
              DateFormat.yMMMd().format(goal.createdDate),
            ),
          ),
          ListTile(
            title: const Text('Due Date'),
            subtitle: Text(
              DateFormat.yMMMd().format(goal.dueDate),
            ),
          ),
          Obx(
            () => ListTile(
              onTap: () {
                goal.isCompleted.toggle();
              },
              title: const Text('Status'),
              subtitle:
                  Text(goal.isCompleted.value ? 'Completed' : 'In Progress'),
            ),
          ),
          if (goal.isRecurring)
            ListTile(
              title: const Text('Recurrence'),
              subtitle: Text(
                _getReccuerence(),
              ),
            )
          else
            const ListTile(
              title: Text('Recurrence'),
              subtitle: Text('None'),
            ),
        ],
      ),
    );
  }
}
