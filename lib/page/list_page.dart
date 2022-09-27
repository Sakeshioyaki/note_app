import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/page/edit_page.dart';
import 'package:note_app/provider/list_page_provider.dart';

import '../main.dart';
import 'note_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  ListPageState listPageState = ListPageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: listPageState.textSearchStream,
          builder: (cont, snapshot) {
            return StreamBuilder(
                stream: listPageState.isSearchingStream,
                builder: (cont, snapshot) {
                  return StreamBuilder(
                    stream: listPageState.isDeletingStream,
                    builder: (cont, snapshot) {
                      return StreamBuilder(
                        stream: listPageState.listIdDeletingStream,
                        builder: (cont, snapshot) {
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'My Notes',
                                                style: AppTextStyle
                                                    .textDarkPrimaryS36Bold,
                                              ),
                                              buildSearch(listPageState),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 24, bottom: 10),
                                                child: Text(
                                                  'Note List',
                                                  style: AppTextStyle
                                                      .textDarkPrimaryS24Bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        listPageState.isSearching
                                            ? buildSearchContent(notes)
                                            : buildListCardNote(notes),
                                      ],
                                    ),
                                  );
                                }),
                            floatingActionButton: listPageState.isSearching
                                ? const SizedBox()
                                : listPageState.isDeleting
                                    ? buildFloatingActionIsDeleteTrue()
                                    : buildFloatingActionIsDeleteFalse(context),
                          );
                        },
                      );
                    },
                  );
                });
          }),
    );
  }

  Expanded buildListCardNote(List<DbNote?> notes) {
    return Expanded(
      child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            var note = notes[index]!;
            print(listPageState.listIdDeleting);
            print('index : ${note.id.v}');
            bool acceptDelete = false;
            for (var element in listPageState.listIdDeleting) {
              {
                element == note.id.v
                    ? (acceptDelete = true)
                    : (acceptDelete = false);
                print(element);
              }
            }
            print('accep ? ${acceptDelete.toString()}');

            return buildListCard(acceptDelete, listPageState.isDeleting,
                note: note);
          }),
    );
  }

  Expanded buildSearchContent(List<DbNote?> notes) {
    return Expanded(
      child:
          buildListSearch(textSearch: listPageState.textSearch, notes: notes),
    );
  }

  Row buildFloatingActionIsDeleteFalse(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildFloatingIcTrash(),
            const SizedBox(
              width: 24,
            ),
            buildFloatingIcAdd(context),
          ],
        ),
      ],
    );
  }

  Container buildFloatingIcAdd(BuildContext context) {
    return Container(
      height: AppDimens.buttonHeight,
      width: AppDimens.buttonHeight,
      decoration: BoxDecoration(
          color: AppColors.greenAccent,
          borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2)),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const EditNotePage(
              initialNote: null,
            );
          }));
        },
        icon: SvgPicture.asset('assets/icons/ic_add.svg', color: Colors.white),
      ),
    );
  }

  Container buildFloatingIcTrash() {
    return Container(
      height: AppDimens.buttonHeight,
      width: AppDimens.buttonHeight,
      decoration: BoxDecoration(
          color: AppColors.redAccent,
          borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2)),
      child: IconButton(
        onPressed: () {
          listPageState.setDeleting();
        },
        icon:
            SvgPicture.asset('assets/icons/ic_trash.svg', color: Colors.white),
      ),
    );
  }

  Container buildFloatingActionIsDeleteTrue() {
    return Container(
      height: AppDimens.buttonHeight,
      width: AppDimens.buttonHeight,
      decoration: BoxDecoration(
          color: AppColors.redAccent,
          borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2)),
      child: IconButton(
        onPressed: () {
          // listPageState.setDeleting();
          listPageState.setDeleting();
        },
        icon: Image.asset(
          'assets/icons/ic_done.png',
          height: 24,
        ),
      ),
    );
  }

  ListView buildListSearch(
      {required String textSearch, required List<DbNote?> notes}) {
    List<DbNote?> resultSearch = [];
    for (var e in notes) {
      if (e!.title.v!.contains(textSearch) ||
          e.content.v!.contains(textSearch)) {
        resultSearch.add(e);
      }
    }
    return ListView.builder(
        itemCount: resultSearch.length,
        itemBuilder: (context, index) {
          var note = resultSearch[index]!;
          print(listPageState.listIdDeleting);
          print('index : ${note.id.v}');
          return Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 18),
              child: buildCard(false, false, note: note, context: context));
        });
  }

  Widget buildListCard(bool? acceptDelete, bool? isDeleting,
      {required DbNote note}) {
    return Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 18),
        child:
            buildCard(isDeleting, acceptDelete, note: note, context: context));
  }

  Widget buildCard(bool? isDeleting, bool? acceptDelete,
      {required DbNote note, required BuildContext context}) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: AppColors.lightBackdround,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
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
        ),
        (isDeleting ?? false)
            ? (acceptDelete == true
                ? SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              listPageState.removeListDeleting(note.id.v);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8)),
                                color: AppColors.greenAccent,
                              ),
                              height: 46,
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icons/ic_close.svg',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await noteProvider.deleteNote(note.id.v);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(8)),
                                color: AppColors.redAccent,
                              ),
                              height: 46,
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/icons/ic_trash.svg',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      listPageState.addListDeleting(note.id.v);
                    },
                    child: Container(
                      height: 46,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.redAccent,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/ic_trash.svg',
                            height: 24),
                      ),
                    ),
                  ))
            : const SizedBox(),
      ],
    );
  }
}

Widget buildSearch(ListPageState listPageState) {
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
      // onTap: (text) {},
      onChanged: (text) {
        if (listPageState.isSearching == false) {
          listPageState.setSearching();
        }
        if (text == '') {
          listPageState.setSearching();
        } else {
          listPageState.setTextSearch(text);
        }
      },
    ),
  );
}
