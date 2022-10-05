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

  Future<void> addNote(String content, String uid, String title) async {
    try {
      await _firestore.collection("users").doc(uid).collection("notes").add({
        'dateCreated': Timestamp.now(),
        'content': content,
        'title': title,
        'done': false,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<NoteModel>> noteStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("notes")
        .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<NoteModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(NoteModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }
}
