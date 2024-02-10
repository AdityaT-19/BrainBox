import 'package:brainbox/controllers/auth_controller.dart';
import 'package:brainbox/controllers/pages_controller.dart';
import 'package:brainbox/routes/app_routes.dart';
import 'package:brainbox/screens/goal/goals_list_screen.dart';
import 'package:brainbox/screens/projects/projects_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _screenController = Get.put(ScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            _screenController.currentPage.value == 0 ? 'Projects' : 'Goals',
            style: Get.textTheme.titleLarge!.copyWith(
              color: Get.theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Get.theme.colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.USERINFO);
            },
            icon: const FaIcon(FontAwesomeIcons.user),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary,
              ),
              child: Text(
                'BrainBox',
                style: Get.textTheme.titleLarge!.copyWith(
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Get.find<AuthController>().signOut();
              },
              icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _screenController.pageController,
        onPageChanged: _screenController.changePage,
        children: [
          ProjectList(),
          GoalList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          if (_screenController.currentPage.value == 0) {
            Get.toNamed(AppRoutes.PROJECTCREATE);
          } else {
            Get.toNamed(AppRoutes.GOALCREATE);
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomNavyBar(
          selectedIndex: _screenController.currentPage.value,
          onItemSelected: _screenController.changePage,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          showElevation: true,
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Projects'),
              activeColor: Get.theme.colorScheme.primary,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.work),
              title: const Text('Goals'),
              activeColor: Get.theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
