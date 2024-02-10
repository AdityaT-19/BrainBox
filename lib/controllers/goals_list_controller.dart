import 'package:brainbox/models/goal.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalListController extends GetxController {
  final goals = <Goal>[].obs;
  final isLoading = true.obs;

  get supabase => Supabase.instance.client;

  @override
  void onInit() {
    //fetchGoals();
    tempFetchGoals();
    super.onInit();
  }

  void fetchGoals() async {
    isLoading(true);
    final response = await supabase.from('goals').select().execute();
    if (response.error != null) {
      print('Error fetching goals: ${response.error!.message}');
    } else {
      goals.clear();
      goals.addAll(
        response.data?.map((e) => Goal.fromJson(e)) ?? [],
      );
    }
    isLoading(false);
  }

  void addGoal(Goal goal) async {
    final response =
        await supabase.from('goals').upsert(goal.toJson()).execute();
    if (response.error != null) {
      print('Error adding goal: ${response.error!.message}');
    } else {
      fetchGoals();
    }
  }

  void deleteGoal(String goalId) async {
    final response =
        await supabase.from('goals').delete().eq('goalId', goalId).execute();
    if (response.error != null) {
      print('Error deleting goal: ${response.error!.message}');
    } else {
      goals.removeWhere((goal) => goal.goalId == goalId);
    }
  }

  void tempFetchGoals() {
    isLoading(true);
    goals.addAll([
      Goal(
        goalId: '1',
        name: 'Learn Flutter',
        description: 'Learn Flutter and build a project',
        createdDate: DateTime.now(),
        dueDate: DateTime.now().add(Duration(days: 30)),
        isCompleted: false.obs,
        isRecurring: false,
        recurrence: Recurrence.none,
        userId: '1',
      ),
      Goal(
        goalId: '2',
        name: 'Learn Dart',
        description: 'Learn Dart and build a project',
        createdDate: DateTime.now(),
        dueDate: DateTime.now().add(Duration(days: 30)),
        isCompleted: false.obs,
        isRecurring: false,
        recurrence: Recurrence.none,
        userId: '1',
      ),
      Goal(
        goalId: '3',
        name: 'Learn Supabase',
        description: 'Learn Supabase and build a project',
        createdDate: DateTime.now(),
        dueDate: DateTime.now().add(Duration(days: 30)),
        isCompleted: false.obs,
        isRecurring: false,
        recurrence: Recurrence.none,
        userId: '1',
      ),
    ]);
    isLoading(false);
  }

  void tempDeleteGoal(String goalId) {
    goals.removeWhere((goal) => goal.goalId == goalId);
  }

  void tempAddGoal(Goal goal) {
    goals.add(goal);
  }
}
