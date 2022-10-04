import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/controller/bindings/authBinding.dart';
import 'package:note_app/controller/user_controller.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/page/login_page.dart';
import 'package:note_app/page/pageHome.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    // Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      home: GetBuilder<UserController>(
        init: UserController(),
        builder: (_) {
          if (Get.find<AuthController>().user?.uid != null) {
            return Home();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
