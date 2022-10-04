import 'package:flutter/material.dart';
import 'package:note_app/model/note_model.dart';

class NoteCard extends StatelessWidget {
  final String uid;
  final NoteModel note;

  const NoteCard({Key? key, required this.uid, required this.note})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                note.content ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
