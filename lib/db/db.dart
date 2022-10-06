import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/model/user_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
      });
      print('dang tao userController - va add user vo database - ${user.id}');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();

      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addNote(
      String content, String uid, String title, Timestamp dateCreated) async {
    try {
      await _firestore.collection("users").doc(uid).collection("notes").add({
        'dateCreated': dateCreated,
        'content': content,
        'title': title,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<NoteModel>> getListNote(String uid) async {
    List<NoteModel> retVal = [];
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("notes")
          .orderBy("dateCreated", descending: true)
          .get()
          .then((value) => value.docs
              .map((e) => retVal.add(NoteModel.fromDocumentSnapshot(e))));

      return retVal;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
