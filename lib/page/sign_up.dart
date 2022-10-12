import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/controller/auth_controller.dart';

class SignUp extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final controller = Get.find<AuthController>();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.people_alt,
                    color: AppColors.greenAccent,
                    size: 30,
                  ),
                  hintText: 'Enter name ...',
                  hintStyle: AppTextStyle.textLightPlaceholderS14,
                ),
                controller: nameController,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.mail,
                    color: AppColors.greenAccent,
                    size: 30,
                  ),
                  hintText: 'Enter email ...',
                  hintStyle: AppTextStyle.textLightPlaceholderS14,
                ),
                controller: emailController,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lock,
                    color: AppColors.greenAccent,
                    size: 30,
                  ),
                  hintText: 'Enter password ...',
                  hintStyle: AppTextStyle.textLightPlaceholderS14,
                ),
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(
                height: 40,
              ),
              OutlinedButton(
                  onPressed: () {
                    controller.createUser(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                    );
                    print(
                        "${nameController.text} - ${emailController.text} - ${passwordController.text}");
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
                        'Sign Up',
                        style: AppTextStyle.textLightPlaceholder,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
