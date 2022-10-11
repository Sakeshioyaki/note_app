import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/db/db.dart';
import 'package:note_app/model/note_model.dart';

class NoteController extends GetxController {
  late List<NoteModel> noteList = [];

  @override
  onInit() async {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    noteList = await Database().getListNote(uid);
    print('dang load list note');
  }

  void createNote(NoteModel note, String uid) async {
    try {
      await Database().addNote(
          note.content ?? '', uid, note.title ?? '', note.dateCreated!);
    } catch (firebaseAuthException) {}
    await getListNote(uid);
    update();
  }

  deleteNote(String id, uid) async {
    try {
      await Database().deleteNote(id, uid);
    } catch (firebaseAuthException) {}
    await getListNote(uid);
    update();
  }

  Future<void> getListNote(String uid) async {
    noteList = await Database().getListNote(uid);
  }
}
