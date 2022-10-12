import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/page/sign_up.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/post-it.png',
                  height: 150,
                ),
                Text(
                  'Note App',
                  style: AppTextStyle.textDarkPrimaryS24Bold,
                ),
              ],
            ),
            const SizedBox(height: 80),
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.people_alt,
                  color: AppColors.greenAccent,
                  size: 30,
                ),
                hintText: 'Enter email ...',
                hintStyle: AppTextStyle.textLightPlaceholderS14,
              ),
              controller: emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.lock,
                  color: AppColors.greenAccent,
                  size: 30,
                ),
                hintText: 'Enter Password ...',
                hintStyle: AppTextStyle.textLightPlaceholderS14,
              ),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Not have account yet ? go to ',
                  style: AppTextStyle.textLightPlaceholderS14,
                ),
                TextButton(
                  child: Text(
                    'Sign Up',
                    style: AppTextStyle.textLightPlaceholderS14Bold,
                  ),
                  onPressed: () {
                    Get.to(SignUp());
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton(
                onPressed: () {
                  authController.login(
                      emailController.text, passwordController.text);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    const BorderSide(
                      color: AppColors.greenAccent,
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: const SizedBox(
                  height: 40,
                  width: 100,
                  child: Center(
                    child: Text(
                      'Login',
                      style: AppTextStyle.textLightPlaceholder,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
