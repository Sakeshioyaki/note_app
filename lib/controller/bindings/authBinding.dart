import 'package:get/get.dart';
import 'package:note_app/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
