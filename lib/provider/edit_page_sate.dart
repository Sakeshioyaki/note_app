import 'dart:async';

class EditPageState {
  bool needAccept = false;
  StreamController needAcceptController = StreamController<bool>.broadcast();
  Stream get needAcceptStream => needAcceptController.stream;

  List<int> listIdDeleting = [];
  StreamController listIdDeletingController =
      StreamController<List<int>>.broadcast();
  Stream get listIdDeletingStream => listIdDeletingController.stream;

  void setDeleting() {
    needAccept = needAccept ? false : true;
    print(needAccept);
    needAcceptController.sink.add(needAccept);
  }
}
