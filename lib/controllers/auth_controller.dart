import 'package:brainbox/controllers/projects_list_controller.dart';
import 'package:brainbox/models/user.dart' as user_model;
import 'package:brainbox/models/user.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brainbox/routes/app_routes.dart';

class AuthController extends GetxController {
  final isAuth = false.obs;
  final isLoading = true.obs;
  final SupabaseClient client = Supabase.instance.client;
  RxBool isLoggedIn = false.obs;
  late Rx<user_model.User> user;

  Future<user_model.User> fetchUserFromSupabase(String uid) async {
    final response =
        await client.from('userdetails').select().eq('uid', uid).single();
    final grpIdResonse =
        await client.from('groupparticipants').select('gid').eq('uid', uid);
    final grpIds = grpIdResonse.map((e) => e['gid'] as String).toList();
    final grpResonse =
        await client.from('groupdetails').select().inFilter('gid', grpIds);
    final user = user_model.User(
      uid: response['uid'] as String,
      name: response['name'] as String,
      username: response['username'] as String,
      gids: grpResonse
          .map(
            (e) => Group(
              gid: e['gid'] as String,
              name: e['gname'] as String,
            ),
          )
          .toList()
          .obs,
      profilePicLink: response['profilepic'] as String?,
    );
    return user;
  }

  @override
  Future<void> onInit() async {
    client.auth.onAuthStateChange.listen((authState) async {
      if (authState.session == null) {
        isLoggedIn.value = false;
        Get.offAllNamed(AppRoutes.LOGIN);
      } else if (authState.session?.accessToken != null) {
        isLoggedIn.value = true;
        user = (await fetchUserFromSupabase(client.auth.currentUser!.id)).obs;
        await Get.putAsync(() async {
          final projectsListController = ProjectsListController();
          return projectsListController;
        }, permanent: true);
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        isLoggedIn.value = false;
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    });
    super.onInit();
  }

  Future<void> signinWithEmailandPassword(String email, String password) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
