import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String? content;
  String? title;
  String? id;
  Timestamp? dateCreated;

  NoteModel(
    this.content,
    this.id,
    this.title,
    this.dateCreated,
  );

  NoteModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    id = documentSnapshot.id;
    final data = documentSnapshot.data() as Map<String, dynamic>;
    content = data["content"];
    title = data["title"];
    dateCreated = data["dateCreated"];
  }
}
