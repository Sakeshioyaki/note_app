import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isDeleting = false.obs;
  RxBool isSearching = false.obs;
  RxList<RxString> listIdDeleting = <RxString>[].obs;
  RxString textSearch = ''.obs;

  void setTextSearch(text) {
    textSearch.value = text;
  }

  void setDeleting() {
    isDeleting.value = isDeleting.value ? false : true;
  }

  void setSearching() {
    isSearching.value = isSearching.value ? false : true;
  }

  void addListDeleting(String? id) {
    listIdDeleting.add(RxString(id!));
  }

  void removeListDeleting(String? id) {
    listIdDeleting.removeWhere((item) => item.value == id);
    print('lít editing $listIdDeleting');
  }
}
