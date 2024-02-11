import 'package:get/get.dart';

enum ProjectStatus {
  proposed,
  inProgress,
  completed,
  paused,
  needsUpdates,
}

class Project {
  final String projectId;
  RxString name;
  RxString description;
  RxList<String> features;
  RxList<String> technologies;
  RxList<String> imageLinks;
  RxnString githubLink;
  RxString groupId;
  Rx<ProjectStatus> status;
  RxnString reportLink;
  Project({
    required this.name,
    required this.description,
    required this.features,
    required this.technologies,
    required this.imageLinks,
    required this.githubLink,
    required this.groupId,
    required this.status,
    required this.projectId,
    required this.reportLink,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['pid'] as String,
      name: (json['name'] as String).obs,
      description: (json['description'] as String).obs,
      features: (json['features'] as List).map((e) => e as String).toList().obs,
      technologies:
          (json['technologies'] as List).map((e) => e as String).toList().obs,
      imageLinks:
          (json['imageLinks'] as List).map((e) => e as String).toList().obs,
      githubLink: RxnString(json['githubLink'] as String?),
      groupId: (json['gid'] as String).obs,
      status: ProjectStatus.values.byName(json['status'] ?? 'proposed').obs,
      reportLink: RxnString(json['reportLink'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'name': name,
      'description': description,
      'features': features,
      'technologies': technologies,
      'imageLinks': imageLinks,
      'githubLink': githubLink,
      'groupId': groupId,
      'status': status.value.name,
    };
  }
}
