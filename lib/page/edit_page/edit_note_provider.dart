import 'package:flutter/foundation.dart';

class EditNoteProvider with ChangeNotifier {
  bool needAccept = false;

  List<int> listIdDeleting = [];

  void setAccept() {
    needAccept = needAccept ? false : true;
    notifyListeners();
  }
}
