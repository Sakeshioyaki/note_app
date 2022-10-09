import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/page/home/pageHome.dart';
import 'package:note_app/page/login_page.dart';

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
        init: Get.put<AuthController>(AuthController(), permanent: true),
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
      ),
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
      ],
    );
  }
}
