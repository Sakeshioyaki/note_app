import 'package:get/get.dart';

class HomeController extends GetxController {
  bool isDeleting = false;
  bool isSearching = false;
  List<String> listIdDeleting = <String>[];
  String textSearch = '';

  void setTextSearch(text) {
    print('come setTextSearch');

    textSearch = text;
    update();
  }

  void setDeleting() {
    print('come setDeleting  -- ${isDeleting}');
    isDeleting = isDeleting ? false : true;
    print('come setDeleting  -- ${isDeleting}');

    update();
  }

  void setSearching() {
    print('come setSearching');
    isSearching = isSearching ? false : true;
    update();
  }

  void addListDeleting(String? id) {
    print('come addListDeleting');
    listIdDeleting.add(id!);
    update();
  }

  void removeListDeleting(String? id) {
    listIdDeleting.removeWhere((item) => item == id);
    print('lít editing $listIdDeleting');
    update();
  }
}
