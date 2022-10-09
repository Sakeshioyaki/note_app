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

  Future<void> deleteNote(
    String noteId,
    String uid,
  ) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("notes")
          .doc(noteId)
          .delete()
          .then(
            (doc) => print("Document deleted -- ${noteId}"),
            onError: (e) => print("Error updating document $e"),
          );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getListNote(String uid) async {
    print('dang getlistnote tu $uid');
    List<NoteModel> retVal = [];
    try {
      final re = await _firestore
          .collection("users")
          .doc(uid)
          .collection("notes")
          .get();
      for (var e in re.docs) {
        retVal.add(NoteModel.fromDocumentSnapshot(e));
        print('this is value -- ${NoteModel.fromDocumentSnapshot(e).title}');
      }
      print('this is reval - $retVal -- ${re.docs.length}');
      return retVal;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
