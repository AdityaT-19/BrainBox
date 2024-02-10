import 'package:get/get.dart';

enum Recurrence {
  none,
  daily,
  weekly,
  fortnightly,
}

class Goal {
  final String goalId;
  final String name;
  final String description;
  final String userId;
  final RxBool isCompleted;
  final bool isRecurring;
  final DateTime dueDate;
  final DateTime createdDate;
  final Recurrence recurrence;

  Goal({
    required this.goalId,
    required this.name,
    required this.description,
    required this.userId,
    required this.isCompleted,
    required this.isRecurring,
    required this.dueDate,
    required this.createdDate,
    required this.recurrence,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalId: json['goalId'],
      name: json['name'],
      description: json['description'],
      userId: json['userId'],
      isCompleted: RxBool(json['isCompleted']),
      isRecurring: json['isRecurring'],
      dueDate: DateTime.parse(json['dueDate']),
      createdDate: DateTime.parse(json['createdDate']),
      recurrence: Recurrence.values.byName(json['recurrence'] ?? 'none'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goalId': goalId,
      'name': name,
      'description': description,
      'userId': userId,
      'isCompleted': isCompleted.value,
      'isRecurring': isRecurring,
      'dueDate':
          '${dueDate.year}-${dueDate.month}-${dueDate.day} ${dueDate.hour}:${dueDate.minute}:${dueDate.second}',
      'createdDate':
          '${createdDate.year}-${createdDate.month}-${createdDate.day} ${createdDate.hour}:${createdDate.minute}:${createdDate.second}',
      'recurrence': recurrence.name,
    };
  }
}
