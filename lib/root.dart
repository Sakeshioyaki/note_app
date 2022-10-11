import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/controller/user_controller.dart';
import 'package:note_app/page/home/pageHome.dart';
import 'package:note_app/page/login_page.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      initState: (_) async {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        if (_.user?.uid != null) {
          print('hull here -- ${_.user?.uid}');
          // Get.find<UserController>().user =
          //     await Database().getUser(authResult.user!.uid);

          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
