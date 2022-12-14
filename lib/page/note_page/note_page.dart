// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
import 'package:note_app/common/app_images.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/main.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/page/edit_page/edit_note_page.dart';

import '../list_note_page/list_note_page.dart';

class NotePage extends StatefulWidget {
  final int? noteId;

  const NotePage({Key? key, required this.noteId}) : super(key: key);

  @override
  NotePageState createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  late bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DbNote?>(
      stream: noteProvider.onNote(widget.noteId),
      builder: (context, snapshot) {
        var note = snapshot.data;
        void edit() {
          if (note != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return EditNotePage(
                    initialNote: note,
                  );
                },
              ),
            );
          }
        }

        return Scaffold(
          body: (note == null)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(children: [
                  ListView(children: [
                    ListTile(
                        title: Text(
                      note.title.v!,
                      style: AppTextStyle.textDarkPrimaryS24Bold,
                    )),
                    ListTile(
                      title: Text(
                        DateFormat('dd MMM y    h:mm a').format(DateTime.now()),
                        style: AppTextStyle.textLightPlaceholderS12,
                      ),
                    ),
                    ListTile(
                        title: Text(
                      note.content.v ?? '',
                      style: AppTextStyle.textDarkPrimaryS14,
                    )),
                  ]),
                ]),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 40),
                  Container(
                    height: AppDimens.buttonHeight,
                    width: AppDimens.buttonHeight,
                    decoration: BoxDecoration(
                      color: AppColors.darkPrimary,
                      borderRadius:
                          BorderRadius.circular(AppDimens.buttonHeight / 2),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(
                        AppImages.icBack,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: AppDimens.buttonHeight,
                    width: AppDimens.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.redAccent,
                        borderRadius:
                            BorderRadius.circular(AppDimens.buttonHeight / 2)),
                    child: IconButton(
                      onPressed: () async {
                        if (await showDialog<bool>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete note?'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text(
                                            'Tap \'YES\' to confirm note deletion.',
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ListNotePage();
                                            }),
                                          );
                                        },
                                        child: Text('YES'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('NO'),
                                      ),
                                    ],
                                  );
                                }) ??
                            false) {
                          await noteProvider.deleteNote(widget.noteId);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      },
                      icon: SvgPicture.asset(
                        AppImages.icTrash,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  Container(
                    height: AppDimens.buttonHeight,
                    width: AppDimens.buttonHeight,
                    decoration: BoxDecoration(
                      color: AppColors.greenAccent,
                      borderRadius: BorderRadius.circular(
                        AppDimens.buttonHeight / 2,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        edit();
                      },
                      icon: SvgPicture.asset(AppImages.icEdit),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
