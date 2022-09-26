import 'dart:async';

class ListPageState {
  bool isDeleting = false;
  StreamController isDeletingController = StreamController<bool>.broadcast();
  Stream get isDeletingStream => isDeletingController.stream;

  List<int> listIdDeleting = [];
  StreamController listIdDeletingController =
      StreamController<List<int>>.broadcast();
  Stream get listIdDeletingStream => listIdDeletingController.stream;

  void setDeleting() {
    isDeleting = isDeleting ? false : true;
    print(isDeleting);
    isDeletingController.sink.add(isDeleting);
  }

  void addListDeleting(int? id) {
    listIdDeleting.add(id ?? -1);
    print('addd ..... {$id}');
    print(listIdDeleting);
    listIdDeletingController.sink.add(listIdDeleting);
  }

  void removeListDeleting(int? id) {
    print('deleting ..... {$id}');
    listIdDeleting.remove(id);
    print(listIdDeleting);
    listIdDeletingController.sink.add(listIdDeleting);
  }
}
