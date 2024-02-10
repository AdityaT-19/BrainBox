import 'package:brainbox/models/project.dart';
import 'package:brainbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectInfo extends StatelessWidget {
  const ProjectInfo({Key? key, required this.project, required this.names})
      : super(key: key);
  final Project project;
  final List<String> names;

  Widget _buildGithubLink() {
    if (project.githubLink != null && project.githubLink!.isNotEmpty) {
      return SelectableLinkify(
        text: project.githubLink!,
        onOpen: (link) async {
          try {
            if (await canLaunchUrl(Uri.parse(link.url))) {
              await launchUrl(Uri.parse(link.url));
            } else {
              throw 'Could not launch $link';
            }
          } catch (e) {
            Get.snackbar('Error !!!', e.toString());
          }
        },
        style: Get.textTheme.headlineSmall!.copyWith(
          color: Get.theme.colorScheme.tertiary,
        ),
      );
    } else {
      return _customBody('No Github Link');
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    return project.status.value == ProjectStatus.completed
        ? Colors.green
        : project.status.value == ProjectStatus.inProgress
            ? Colors.blue
            : project.status.value == ProjectStatus.paused
                ? Colors.orange
                : project.status.value == ProjectStatus.needsUpdates
                    ? Colors.yellow
                    : Colors.red;
  }

  Widget _customHeading(String text) {
    return Container(
      padding: EdgeInsets.all(
        Get.height * 0.01,
      ),
      child: Text(
        text,
        style: Get.textTheme.headlineMedium!.copyWith(
          color: Get.theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _customBody(String text) {
    return Container(
      padding: EdgeInsets.all(
        Get.height * 0.01,
      ),
      child: Text(
        text,
        style: Get.textTheme.headlineSmall!.copyWith(
          color: Get.theme.colorScheme.tertiary,
        ),
      ),
    );
  }

  Widget _customIndex(int index) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.theme.colorScheme.background,
        border: Border.all(
          color: Get.theme.colorScheme.secondary,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(Get.height * 0.005),
      child: Padding(
        padding: EdgeInsets.all(Get.height * 0.005),
        child: Text(
          '$index',
          style: Get.textTheme.headlineSmall!.copyWith(
            color: Get.theme.colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          project.name,
          style: Get.textTheme.titleLarge!.copyWith(
            color: Get.theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Get.theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: _customHeading('Name'),
              subtitle: _customBody(project.name),
            ),
            Container(
              padding: EdgeInsets.all(
                Get.height * 0.01,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(
                    Get.height * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _customHeading('Status'),
                      Container(
                        height: Get.height * 0.05,
                        width: Get.width * 0.3,
                        margin: EdgeInsets.only(
                          top: Get.height * 0.01,
                        ),
                        padding: EdgeInsets.all(
                          Get.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          gradient: LinearGradient(
                            colors: [
                              _getStatusColor(project.status.value),
                              _getStatusColor(project.status.value)
                                  .withOpacity(0.5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          project.status.value.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Get.theme.colorScheme.inverseSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: _customHeading('Description'),
              subtitle: _customBody(project.description),
            ),
            ListTile(
              title: _customHeading('Github Link'),
              subtitle: _buildGithubLink(),
            ),
            ListTile(
                title: _customHeading('Group Members'),
                subtitle: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: _customIndex(
                        index + 1,
                      ),
                      subtitle: _customBody(
                        names[index],
                      ),
                    );
                  },
                )),
            ListTile(
                title: _customHeading('Features'),
                subtitle: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: project.features.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: _customIndex(
                        index + 1,
                      ),
                      subtitle: _customBody(
                        project.features[index],
                      ),
                    );
                  },
                )),
            ListTile(
              title: _customHeading('Technologies Used'),
              subtitle: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: project.technologies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _customIndex(
                      index + 1,
                    ),
                    subtitle: _customBody(
                      project.technologies[index],
                    ),
                  );
                },
              ),
            ),
            if (project.reportLink != null && project.reportLink!.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.VIEWPDF,
                      arguments: project.reportLink!);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.filePdf,
                ),
                label: const Text('View Report'),
              ),
            ListTile(
              title: _customHeading('Screenshots'),
              subtitle: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: project.imageLinks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Image.network(
                      project.imageLinks[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Error Loading Image');
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
