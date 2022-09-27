import 'dart:async';

class ListNoteProvider {
  bool isDeleting = false;
  StreamController isDeletingController = StreamController<bool>.broadcast();
  Stream get isDeletingStream => isDeletingController.stream;

  bool isSearching = false;
  StreamController isSearchingController = StreamController<bool>.broadcast();
  Stream get isSearchingStream => isSearchingController.stream;

  List<int> listIdDeleting = [];
  StreamController listIdDeletingController =
      StreamController<List<int>>.broadcast();
  Stream get listIdDeletingStream => listIdDeletingController.stream;

  String textSearch = '';
  StreamController textSearchController = StreamController<String>.broadcast();
  Stream get textSearchStream => textSearchController.stream;

  void setTextSearch(text) {
    textSearch = text;
    textSearchController.sink.add(textSearch);
  }

  void setDeleting() {
    isDeleting = isDeleting ? false : true;
    isDeletingController.sink.add(isDeleting);
  }

  void setSearching() {
    isSearching = isSearching ? false : true;
    isSearchingController.sink.add(isSearching);
  }

  void addListDeleting(int? id) {
    listIdDeleting.add(id ?? -1);
    print('lít editing ${listIdDeleting}');
    listIdDeletingController.sink.add(listIdDeleting);
  }

  void removeListDeleting(int? id) {
    listIdDeleting.remove(id);
    print('lít editing ${listIdDeleting}');
    listIdDeletingController.sink.add(listIdDeleting);
  }
}
