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
  final String name;
  final String description;
  final List<String> features;
  final List<String> technologies;
  final List<String> imageLinks;
  final String? githubLink;
  final String groupId;
  final Rx<ProjectStatus> status;
  final String? reportLink;
  Project({
    required this.name,
    required this.description,
    required this.features,
    required this.technologies,
    required this.imageLinks,
    this.githubLink,
    required this.groupId,
    required this.status,
    required this.projectId,
    this.reportLink,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['pid'],
      name: json['name'],
      description: json['description'],
      features: (json['features'] as List).map((e) => e as String).toList(),
      technologies:
          (json['technologies'] as List).map((e) => e as String).toList(),
      imageLinks: (json['imageLinks'] as List).map((e) => e as String).toList(),
      githubLink: json['githubLink'],
      groupId: json['gid'],
      status: Rx<ProjectStatus>(
        ProjectStatus.values.byName(json['status'] ?? 'proposed'),
      ),
      reportLink: json['reportLink'],
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
