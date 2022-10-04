import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:note_app/controller/user_controller.dart';
import 'package:note_app/db/db.dart';
import 'package:note_app/model/user_model.dart';
import 'package:note_app/page/login_page.dart';
import 'package:note_app/page/pageHome.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  User? get user => firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      print('da co user - ${user.email}');
      Get.offAll(() => Home());
    }
    print('this cureetn ${this.user?.email}');
  }

  void createUser(
    String email,
    String password,
    String name,
  ) async {
    try {
      print('come to create user ???... ${name}');
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(
          'creted user  - ${authResult.user?.uid} - ${authResult.user?.email}');
      UserModel _user = UserModel(
        id: authResult.user!.uid,
        name: name,
        email: authResult.user!.email,
      );
      if (await Database().createNewUser(_user)) {
        Get.find<UserController>().user = _user;

        Get.back();
      }
    } catch (firebaseAuthException) {}
  }

  void login(String email, password) async {
    print('longingggg..');
    try {
      UserCredential authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.find<UserController>().user =
          await Database().getUser(authResult.user!.uid);
    } catch (firebaseAuthException) {
      print('longingggg.. error');
    }
  }

  void signOut() async {
    await auth.signOut();
    Get.find<UserController>().clear();
  }
}
