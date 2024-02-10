import 'package:brainbox/controllers/auth_controller.dart';
import 'package:brainbox/screens/login_screen/widgets/email_field.dart';
import 'package:brainbox/screens/login_screen/widgets/get_started_button.dart';
import 'package:brainbox/screens/login_screen/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  double _elementsOpacity = 1;
  double loadingBallSize = 1;

  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 1, end: _elementsOpacity),
                  builder: (_, value, __) => Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets\\images\\brainbox_icon.png',
                            height: Get.height * 0.3,
                            width: Get.width * 0.7,
                            alignment: Alignment.center,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.05),
                        Text(
                          "Welcome,",
                          style: Get.textTheme.displayMedium!.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                          ),
                        ),
                        Text(
                          "Sign in to continue",
                          style: Get.textTheme.displaySmall!.copyWith(
                            color: Get.theme.colorScheme.onBackground
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                  child: Column(
                    children: [
                      EmailField(
                          fadeEmail: _elementsOpacity == 0,
                          emailController: emailController),
                      SizedBox(height: Get.height * 0.03),
                      PasswordField(
                          fadePassword: _elementsOpacity == 0,
                          passwordController: passwordController),
                      SizedBox(height: Get.height * 0.03),
                      GetStartedButton(
                        elementsOpacity: _elementsOpacity,
                        onTap: () async {
                          setState(() {
                            _elementsOpacity = 0;
                          });
                          _authController.signinWithEmailandPassword(
                              emailController.text, passwordController.text);
                          Future.delayed(Duration(milliseconds: 500))
                              .then((value) {
                            if (!_authController.isLoggedIn.value) {
                              setState(() {
                                _elementsOpacity = 1;
                              });
                            }
                          });
                        },
                        onAnimatinoEnd: () {},
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
