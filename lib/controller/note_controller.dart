import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/db/db.dart';
import 'package:note_app/model/note_model.dart';

class NoteController extends GetxController {
  late Rx<List<NoteModel>> noteList = Rx<List<NoteModel>>([]);

  @override
  onInit() async {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    noteList.value = await Database().getListNote(uid);
    print('dang load list note');
  }

  void createNote(String content, String uid, String title) async {
    try {
      await Database().addNote(content, uid, title, Timestamp.now());
    } catch (firebaseAuthException) {}
  }

  deleteNote(String id, uid) async {
    try {
      await Database().deleteNote(id, uid);
    } catch (firebaseAuthException) {}
  }
}
