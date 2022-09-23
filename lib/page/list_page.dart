import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/main.dart';
import 'package:note_app/model/model.dart';

import 'edit_page.dart';
import 'note_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<DbNote?>>(
        stream: noteProvider.onNotes(),
        builder: (context, snapshot) {
          var notes = snapshot.data;
          if (notes == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Notes',
                        style: AppTextStyle.textDarkPrimaryS36Bold,
                      ),
                      buildSearch(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Note List',
                          style: AppTextStyle.textDarkPrimaryS24Bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        var note = notes[index]!;
                        return buildListCard(note, context);
                      }),
                ),
              ],
            ),
          );
        },
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return const NoteListPage();
                                      }));
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
                      // await noteProvider.deleteNote(widget.noteId);
                      // Pop twice to go back to the list
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
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
          )
        ],
      ),
    );
  }

  Widget buildListCard(DbNote note, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: buildCard(note, context)
        // ListTile(
        //   title: Text(note.title.v ?? ''),
        //   subtitle: note.content.v?.isNotEmpty ?? false
        //       ? Text(LineSplitter.split(note.content.v!).first)
        //       : null,
        //   onTap: () {
        //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //       return NotePage(
        //         noteId: note.id.v,
        //       );
        //     }));
        //   },
        // ),
        );
  }

  Widget buildCard(DbNote note, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: AppColors.lightBackdround,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NotePage(
              noteId: note.id.v,
            );
          }));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title.v ?? '',
                style: AppTextStyle.textDarkPrimaryS18,
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                LineSplitter.split(note.content.v!).first,
                style: AppTextStyle.textDarkPrimaryS14,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildSearch() {
  return Padding(
    padding: const EdgeInsets.only(top: 24),
    child: TextField(
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightBackdround,
        constraints: const BoxConstraints(minHeight: 52, maxHeight: 52),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(17),
          child: SvgPicture.asset('assets/icons/ic_search.svg',
              height: 18, semanticsLabel: 'A red up arrow'),
        ),
        hintText: 'Search',
        hintStyle: AppTextStyle.textLightPlaceholderS14,
        helperStyle: AppTextStyle.textLightPlaceholderS14,
        alignLabelWithHint: false,
      ),
      style: AppTextStyle.textLightPlaceholderS14,
      onTap: () => {},
    ),
  );
}
