import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/page/login_page/login_page.dart';
import 'package:note_app/page/note_page/note_provider.dart';

late DbNoteProvider noteProvider;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await noteProvider.ready;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
