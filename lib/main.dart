import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/page/home/pageHome.dart';
import 'package:note_app/page/login_page.dart';
import 'package:note_app/page/note/note_page.dart';
import 'package:note_app/page/sign_up.dart';
import 'package:note_app/root.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {});

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put<AuthController>(AuthController(), permanent: true);

    return GetMaterialApp(
      home: Root(),
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/note', page: () => NotePage()),
        GetPage(name: '/signUp', page: () => SignUp()),
      ],
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       home: Root(),
//       getPages: [
//         GetPage(name: '/', page: () => const HomePage()),
//         GetPage(name: '/login', page: () => LoginPage()),
//       ],
//     );
//   }
// }
