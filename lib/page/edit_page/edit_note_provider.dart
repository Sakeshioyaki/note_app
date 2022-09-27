import 'dart:async';

class EditNoteProvider {
  bool needAccept = false;
  StreamController needAcceptController = StreamController<bool>.broadcast();
  Stream get needAcceptStream => needAcceptController.stream;

  List<int> listIdDeleting = [];
  StreamController listIdDeletingController =
      StreamController<List<int>>.broadcast();
  Stream get listIdDeletingStream => listIdDeletingController.stream;

  void setAccept() {
    needAccept = needAccept ? false : true;
    needAcceptController.sink.add(needAccept);
  }
}
