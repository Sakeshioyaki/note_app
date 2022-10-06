import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
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
      // unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()),
      home: GetX<AuthController>(
        initState: (_) async {
          Get.put<UserController>(UserController());
        },
        builder: (_) {
          if (_.user?.uid != null) {
            return Home();
          } else {
            return LoginPage();
          }
        },
      ),
      getPages: [
        GetPage(name: '/', page: () => Home()),
        GetPage(name: '/login', page: () => LoginPage()),
      ],
    );
  }
}
