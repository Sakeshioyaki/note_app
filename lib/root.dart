import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/controller/user_controller.dart';
import 'package:note_app/page/home/pageHome.dart';
import 'package:note_app/page/login_page.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<UserController>(UserController());

    return GetX(
      builder: (_) {
        if (Get.find<AuthController>().user?.uid != null) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
