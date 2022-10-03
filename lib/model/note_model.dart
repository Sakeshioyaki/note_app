import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String? content;
  String? id;
  Timestamp? dateCreated;

  NoteModel(
      this.content,
      this.id,
      this.dateCreated,
      );

  NoteModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot,
      ) {
    id = documentSnapshot.id;
    content = documentSnapshot.data([content]);
    dateCreated = documentSnapshot.data["dateCreated"];
  }