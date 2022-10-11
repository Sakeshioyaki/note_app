import 'package:get/get.dart';

class EditNoteController extends GetxController {
  bool needAccept = false;

  void setAccept() {
    needAccept = needAccept ? false : true;
    update();
  }
}
