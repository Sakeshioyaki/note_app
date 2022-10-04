import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/controller/note_controller.dart';
import 'package:note_app/controller/user_controller.dart';
import 'package:note_app/db/db.dart';
import 'package:note_app/page/widgets/todo_card.dart';

class Home extends GetWidget<AuthController> {
  final TextEditingController _noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<UserController>(
          initState: (_) async {
            Get.find<UserController>().user =
                await Database().getUser(Get.find<AuthController>().user!.uid);
          },
          builder: (_) {
            if (_.user.name != null) {
              return Text("Welcome  + ${_.user.name}");
            } else {
              return const Text("loading...");
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              controller.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (Get.isDarkMode) {
                Get.changeTheme(ThemeData.light());
              } else {
                Get.changeTheme(ThemeData.dark());
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Add Todo Here:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _noteController,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_noteController.text != "") {
                        Database().addnote(
                            _noteController.text, controller.user!.uid);
                        _noteController.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          const Text(
            "Your notes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GetX<NoteController>(
            init: Get.put<NoteController>(NoteController()),
            builder: (NoteController noteController) {
              if (noteController != null && noteController.notes != null) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: noteController.notes.length,
                    itemBuilder: (_, index) {
                      return NoteCard(
                        uid: controller.user!.uid,
                        note: noteController.notes[index],
                      );
                    },
                  ),
                );
              } else {
                return const Text("loading...");
              }
            },
          )
        ],
      ),
    );
  }
}
