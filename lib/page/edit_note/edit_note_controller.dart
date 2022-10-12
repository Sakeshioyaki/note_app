import 'package:get/get.dart';

class EditNoteController extends GetxController {
  bool needAccept = false;
  String fileUrl = '';

  void setAccept() {
    needAccept = needAccept ? false : true;
    update();
  }

  void setFileUrl(String url) {
    fileUrl = url;
    update();
  }
}
