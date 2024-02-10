import 'package:brainbox/controllers/auth_controller.dart';
import 'package:brainbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Get.find<AuthController>().isLoggedIn.value
            ? Get.offAllNamed(AppRoutes.HOME)
            : Get.offAllNamed(AppRoutes.LOGIN);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }

      if (Get.find<AuthController>().isLoggedIn.value) {
        final authCont = Get.find<AuthController>();
        Supabase.instance.client
            .channel('public:groupparticipants')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'groupparticipants',
              callback: (payload) async {
                print('Change received: ${payload.toString()}');
                print(authCont.user.value.gids);
                authCont.user = (await authCont.fetchUserFromSupabase(
                        authCont.client.auth.currentUser!.id))
                    .obs;
                print(authCont.user.value.gids);
              },
            )
            .subscribe();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (Get.find<AuthController>().isLoggedIn.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
