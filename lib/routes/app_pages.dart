import 'package:brainbox/bindings/goal_create_bindings.dart';
import 'package:brainbox/bindings/home_page_bindings.dart';
import 'package:brainbox/bindings/project_create_bindings.dart';
import 'package:brainbox/routes/app_routes.dart';
import 'package:brainbox/screens/goal/goal_create.dart';
import 'package:brainbox/screens/goal/goal_info.dart';
import 'package:brainbox/screens/home_page.dart';
import 'package:brainbox/screens/login_screen/login_screen.dart';
import 'package:brainbox/screens/projects/project_create.dart';
import 'package:brainbox/screens/projects/project_info.dart';
import 'package:brainbox/screens/projects/project_update.dart';
import 'package:brainbox/screens/splash_screen.dart';
import 'package:brainbox/screens/user_info.dart';
import 'package:brainbox/screens/view_pdf_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomePageBindings(),
    ),
    GetPage(
      name: AppRoutes.PROJECTCREATE,
      page: () => ProjectCreate(),
      binding: ProjectCreateBindings(),
    ),
    GetPage(
      name: AppRoutes.GOALCREATE,
      page: () => GoalCreate(),
      binding: GoalCreateBindings(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.PROJECTINFO,
      page: () {
        final _project = (Get.arguments as Set).elementAt(0);
        final _names = (Get.arguments as Set).elementAt(1);
        return ProjectInfo(project: _project, names: _names);
      },
    ),
    GetPage(
      name: AppRoutes.GOALINFO,
      page: () {
        final _goal = Get.arguments;
        return GoalInfo(goal: _goal);
      },
    ),
    GetPage(
      name: AppRoutes.USERINFO,
      page: () => UserInfo(),
    ),
    GetPage(
      name: AppRoutes.VIEWPDF,
      page: () {
        final _url = Get.arguments;
        return ViewPdfPage(url: _url);
      },
    ),
  ];
}
