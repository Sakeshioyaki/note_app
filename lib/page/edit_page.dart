import 'package:flutter/material.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/main.dart';
import 'package:note_app/model/model.dart';

class EditNotePage extends StatefulWidget {
  /// null when adding a note
  final DbNote? initialNote;

  const EditNotePage({Key? key, required this.initialNote}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _titleTextController;
  TextEditingController? _contentTextController;

  int? get _noteId => widget.initialNote?.id.v;
  @override
  void initState() {
    super.initState();
    _titleTextController =
        TextEditingController(text: widget.initialNote?.title.v);
    _contentTextController =
        TextEditingController(text: widget.initialNote?.content.v);
  }

  Future save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await noteProvider.saveNote(DbNote()
        ..id.v = _noteId
        ..title.v = _titleTextController!.text
        ..content.v = _contentTextController!.text
        ..date.v = DateTime.now().millisecondsSinceEpoch);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Pop twice when editing
      if (_noteId != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var dirty = false;
        if (_titleTextController!.text != widget.initialNote?.title.v) {
          dirty = true;
        } else if (_contentTextController!.text !=
            widget.initialNote?.content.v) {
          dirty = true;
        }
        if (dirty) {
          return await (showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Discard change?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('Content has changed.'),
                            SizedBox(
                              height: 12,
                            ),
                            Text('Tap \'CONTINUE\' to discard your changes.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('CONTINUE'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('CANCEL'),
                        ),
                      ],
                    );
                  })) ??
              false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Note',
          ),
          actions: <Widget>[
            if (_noteId != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  if (await showDialog<bool>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete note?'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                        'Tap \'YES\' to confirm note deletion.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('YES'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('NO'),
                                ),
                              ],
                            );
                          }) ??
                      false) {
                    await noteProvider.deleteNote(widget.initialNote!.id.v);
                    // Pop twice to go back to the list
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
              ),
            // action button
            IconButton(
              icon: const Icon(Icons.save_alt),
              onPressed: () {
                save();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Write title here ...',
                          labelStyle: AppTextStyle.textLightPlaceholderS24,
                          border: InputBorder.none,
                        ),
                        controller: _titleTextController,
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Title must not be empty',
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Write content here ...',
                          border: InputBorder.none,
                        ),
                        controller: _contentTextController,
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Description must not be empty',
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      )
                    ]))
          ]),
        ),
      ),
    );
  }
}
