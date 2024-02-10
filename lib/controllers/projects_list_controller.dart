import 'package:brainbox/controllers/auth_controller.dart';
import 'package:brainbox/models/project.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectsListController extends GetxController {
  final projects = <Project>[].obs;
  final isLoading = true.obs;
  final _authController = Get.find<AuthController>();

  final supabase = Supabase.instance.client;

  @override
  Future<void> onInit() async {
    await fetchProjects();
    subscribeToProjectChanges();
    super.onInit();
  }

  void subscribeToProjectChanges() {
    supabase
        .channel('public:project')
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'project',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.inFilter,
            column: 'gid',
            value: _authController.user.value.gids
                .map((element) => element.gid)
                .toList(),
          ),
          callback: (payload) async {
            isLoading(true);
            final projectId = payload.oldRecord['pid'] as String;
            projects.removeWhere((element) => element.projectId == projectId);
            isLoading(false);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'project',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.inFilter,
            column: 'gid',
            value: _authController.user.value.gids
                .map((element) => element.gid)
                .toList(),
          ),
          callback: (payload) async {
            print('inserted');
            print(payload);
            isLoading(true);
            final projectId = payload.newRecord['pid'] as String;
            final project = await fetchProject(projectId);
            projects.add(project);
            isLoading(false);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'project',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.inFilter,
            column: 'gid',
            value: _authController.user.value.gids
                .map((element) => element.gid)
                .toList(),
          ),
          callback: (payload) async {
            print('updated');
            print(payload);
            isLoading(true);
            final projectId = payload.newRecord['pid'] as String;
            final index = projects
                .indexWhere((element) => element.projectId == projectId);
            projects.removeAt(index);
            final project = await fetchProject(projectId);
            projects.insert(index, project);
            isLoading(false);
          },
        )
        .subscribe();
  }

  Future<void> fetchProjects() async {
    isLoading(true);
    projects.clear();
    print('called fetchProjects');
    final gids =
        _authController.user.value.gids.map((element) => element.gid).toList();
    print('gids : $gids');
    final response =
        await supabase.from('project').select('pid').inFilter('gid', gids);
    print(response);
    final pids = response.map((e) => e['pid'] as String).toList();
    print('pids : $pids');
    for (var pid in pids) {
      final project = await fetchProject(pid);
      projects.add(project);
    }
    isLoading(false);
  }

  Future<Project> fetchProject(String projectId) async {
    print('called fetchProject');
    final response =
        await supabase.from('project').select().eq('pid', projectId).single();
    final project = Project.fromJson(response);
    print(project);
    return project;
  }

  void deleteProject(String pid) async {
    final response =
        await supabase.from('project').delete().eq('pid', pid).select();
    print(response);
  }

  // void addProject(Project project) async {
  //   final response =
  //       await supabase.from('projects').upsert(project.toJson()).execute();
  //   if (response.error != null) {
  //     print('Error adding project: ${response.error!.message}');
  //   } else {
  //     fetchProjects();
  //   }
  // }

  // void deleteProject(String projectId) async {
  //   final response = await supabase
  //       .from('projects')
  //       .delete()
  //       .eq('projectId', projectId)
  //       .execute();
  //   if (response.error != null) {
  //     print('Error deleting project: ${response.error!.message}');
  //   } else {
  //     projects.removeWhere((project) => project.projectId == projectId);
  //   }
  // }

  //subscribe to changes in the projects table
  // void getProjectFromOtherUsers() {
  //   final subscription =
  //       supabase.from('projects').on(SupabaseEventTypes.insert, (payload) {
  //     final newProject = Project.fromJson(payload.newRecord);
  //     projects.add(newProject);
  //   }).subscribe();
  // }

  // void deleteProjectFromOtherUsers() {
  //   final subscription =
  //       supabase.from('projects').on(SupabaseEventTypes.delete, (payload) {
  //     final deletedProjectId = payload.oldRecord['projectId'] as String;
  //     projects.removeWhere((project) => project.projectId == deletedProjectId);
  //   }).subscribe();
  // }

  // void tempFetchProjects() {
  //   projects.clear();
  //   projects.addAll(List.generate(
  //       5,
  //       (index) => Project(
  //             projectId: '$index',
  //             name: 'Project $index',
  //             description: 'Description $index',
  //             groupId: '$index',
  //             features: List.generate(5, (index) => 'Feature $index'),
  //             imageLinks: [],
  //             technologies: List.generate(5, (index) => 'Technology $index'),
  //             status: ProjectStatus.proposed.obs,
  //           )));

  //   isLoading(false);
  // }

  // void tempAddProject(Project project) {
  //   projects.add(project);
  // }

  // void tempDeleteProject(String projectId) {
  //   projects.removeWhere((project) => project.projectId == projectId);
  // }
}
