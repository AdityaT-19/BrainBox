import 'package:brainbox/controllers/projects_list_controller.dart';
import 'package:brainbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectList extends StatelessWidget {
  ProjectList({super.key});

  final ProjectsListController _projectListController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_projectListController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Obx(
          () => (ListView.builder(
            itemCount: _projectListController.projects.length,
            itemBuilder: (context, index) {
              if (_projectListController.projects.isEmpty) {
                return const Center(
                  child: Text('No projects found',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                      )),
                );
              }
              return Slidable(
                key: Key(_projectListController.projects[index].projectId),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _projectListController.deleteProject(
                          _projectListController.projects[index].projectId,
                        );
                      },
                      backgroundColor: Get.theme.colorScheme.error,
                      foregroundColor: Get.theme.colorScheme.onError,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  child: ListTile(
                    title:
                        Text(_projectListController.projects[index].name.value),
                    subtitle: Text(_projectListController
                        .projects[index].description.value),
                    onTap: () async {
                      final project = _projectListController.projects[index];
                      Future<List<String>> _buildGroupMembers() async {
                        final supabase = Supabase.instance.client;
                        final uidsRes = await supabase
                            .from('groupparticipants')
                            .select('uid')
                            .eq('gid', project.groupId);
                        final uids =
                            uidsRes.map((e) => e['uid'] as String).toList();
                        print(uids);
                        final names = await supabase
                            .from('userdetails')
                            .select('name')
                            .inFilter('uid', uids);
                        final groupMembers =
                            names.map((e) => e['name'] as String).toList();
                        print(groupMembers);

                        return groupMembers;
                      }

                      final names = await _buildGroupMembers();
                      Get.toNamed(
                        AppRoutes.PROJECTINFO,
                        arguments: {project, names},
                      );
                    },
                  ),
                ),
              );
            },
          )),
        );
      }),
    );
  }
}
