import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/db/db.dart';
import 'package:note_app/model/note_model.dart';

class NoteController extends GetxController {
  late Rx<List<NoteModel>> noteList = Rx<List<NoteModel>>([]);

  List<NoteModel> get notes => noteList.value;

  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    noteList
        .bindStream(Database().noteStream(uid)); //stream coming from firebase
  }

  void addNewNote(NoteModel note) {}
}
