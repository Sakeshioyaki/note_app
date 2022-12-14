import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_app/page/list_note_page/list_note_page.dart';
import 'package:note_app/page/note_page/note_provider.dart';
import 'package:sqflite/sqflite.dart';

late DbNoteProvider noteProvider;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  noteProvider = DbNoteProvider(databaseFactory);
  await noteProvider.ready;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotePad',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListNotePage(),
    );
  }
}
