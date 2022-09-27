import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/main.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/provider/edit_page_sate.dart';

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
  EditPageState editPageState = EditPageState();

  TextEditingController? _titleTextController;
  TextEditingController? _contentTextController;

  int? get _noteId => widget.initialNote?.id.v;
  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(
        text: widget.initialNote?.title.v ?? 'Write title here ...');
    _contentTextController = TextEditingController(
        text: widget.initialNote?.content.v ?? 'Write content here ...');
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
    return StreamBuilder(
        stream: editPageState.needAcceptStream,
        builder: (cont, snapshot) {
          return Scaffold(
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
                              border: InputBorder.none,
                            ),
                            controller: _titleTextController,
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : 'Title must not be empty',
                          ),
                          Text(
                            DateFormat('dd MMM y    h:mm a')
                                .format(DateTime.now()),
                            style: AppTextStyle.textLightPlaceholderS12,
                          ),
                          TextFormField(
                            // textAlignVertical: TextAlignVertical.top,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: InputBorder.none,
                              filled: true,
                              // fillColor: Colors.black12,
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
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: AppDimens.buttonHeight,
                    width: AppDimens.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.darkPrimary,
                        borderRadius:
                            BorderRadius.circular(AppDimens.buttonHeight / 2)),
                    child: IconButton(
                      onPressed: () async {
                        var dirty = false;
                        if (_titleTextController!.text !=
                            widget.initialNote?.title.v) {
                          dirty = true;
                        } else if (_contentTextController!.text !=
                            widget.initialNote?.content.v) {
                          dirty = true;
                        }
                        if (dirty) {
                          print('dity ${dirty}');
                          showDialog<bool>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                                        Text(
                                            'Tap \'CONTINUE\' to discard your changes.'),
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
                              });
                        }
                      },
                      icon: SvgPicture.asset('assets/icons/ic_back.svg',
                          color: Colors.white),
                    ),
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
                        save();
                      },
                      icon: Image.asset('assets/icons/ic_save.png',
                          width: 24, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
