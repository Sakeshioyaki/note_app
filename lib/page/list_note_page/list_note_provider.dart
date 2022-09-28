import 'package:flutter/foundation.dart';

class ListNoteProvider with ChangeNotifier {
  bool isDeleting = false;

  bool isSearching = false;

  List<int> listIdDeleting = [];

  String textSearch = '';

  void setTextSearch(text) {
    textSearch = text;
    notifyListeners();
  }

  void setDeleting() {
    isDeleting = isDeleting ? false : true;
    notifyListeners();
  }

  void setSearching() {
    isSearching = isSearching ? false : true;
    notifyListeners();
  }

  void addListDeleting(int? id) {
    listIdDeleting.add(id ?? -1);
    notifyListeners();
  }

  void removeListDeleting(int? id) {
    listIdDeleting.remove(id);
    print('lít editing ${listIdDeleting}');
    notifyListeners();
  }
}
