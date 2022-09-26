import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
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
                      Text(
                        '13 Mar 2022 19:02 WIB',
                        style: AppTextStyle.textLightPlaceholderS12,
                      ),
                      TextFormField(
                        // textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Write content here ...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.black12,
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: AppDimens.buttonHeight,
                  width: AppDimens.buttonHeight,
                  decoration: BoxDecoration(
                      color: AppColors.redAccent,
                      borderRadius:
                          BorderRadius.circular(AppDimens.buttonHeight / 2)),
                  child: IconButton(
                    onPressed: () {
                      listPageState.setDeleting();
                    },
                    icon: SvgPicture.asset('assets/icons/ic_trash.svg',
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Container(
                  height: AppDimens.buttonHeight,
                  width: AppDimens.buttonHeight,
                  decoration: BoxDecoration(
                      color: AppColors.greenAccent,
                      borderRadius:
                          BorderRadius.circular(AppDimens.buttonHeight / 2)),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const EditNotePage(
                          initialNote: null,
                        );
                      }));
                    },
                    icon: SvgPicture.asset('assets/icons/ic_add.svg',
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
