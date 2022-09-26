import 'dart:async';

class ListPageState {
  bool isDeleting = false;
  StreamController isDeletingController = StreamController<bool>();
  Stream get isDeletingStream => isDeletingController.stream;

  List<int> listIdDeleting = [];
  StreamController listIdDeletingController = StreamController<bool>();
  Stream get listIdDeletingStream => listIdDeletingController.stream;

  void setDeleting() {
    isDeleting = isDeleting ? false : true;
    print(isDeleting);
    isDeletingController.sink.add(isDeleting);
  }

  void addListDeleting(int id) {
    listIdDeleting.add(id);
    listIdDeletingController.sink.add(listIdDeleting);
  }
}
