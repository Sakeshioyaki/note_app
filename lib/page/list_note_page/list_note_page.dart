import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
import 'package:note_app/common/app_images.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/main.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/page/edit_page/edit_note_page.dart';
import 'package:note_app/page/list_note_page/list_note_provider.dart';
import 'package:note_app/page/note_page/note_page.dart';

class ListNotePage extends StatefulWidget {
  const ListNotePage({Key? key}) : super(key: key);

  @override
  ListNotePageState createState() => ListNotePageState();
}

class ListNotePageState extends State<ListNotePage> {
  ListNoteProvider listPageState = ListNoteProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: listPageState.textSearchStream,
        builder: (cont, snapshot) {
          return StreamBuilder(
            stream: listPageState.isSearchingStream,
            builder: (cont, snapshot) {
              return buildBody(context);
            },
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder(
      stream: listPageState.isDeletingStream,
      builder: (cont, snapshot) {
        return StreamBuilder(
          stream: listPageState.listIdDeletingStream,
          builder: (cont, snapshot) {
            return Scaffold(
              body: buildMyNote(),
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
  }

  Widget buildMyNote() {
    return StreamBuilder<List<DbNote?>>(
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
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Notes',
                      style: AppTextStyle.textDarkPrimaryS36Bold,
                    ),
                    buildSearch(listPageState),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        bottom: 10,
                      ),
                      child: Text(
                        'Note List',
                        style: AppTextStyle.textDarkPrimaryS24Bold,
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
      },
    );
  }

  Widget buildListCardNote(List<DbNote?> notes) {
    print('list editing ... ${listPageState.listIdDeleting}');
    return Expanded(
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          var note = notes[index]!;
          bool acceptDelete = false;
          for (var element in listPageState.listIdDeleting) {
            {
              if (element == note.id.v) (acceptDelete = true);
            }
            // print('index : ${element} - ${note.id.v}-  ${acceptDelete}');
          }

          print('index : ${index} - ${note.id.v}-  ${acceptDelete}');
          return buildListCard(
            acceptDelete,
            listPageState.isDeleting,
            note: note,
          );
        },
      ),
    );
  }

  Widget buildSearchContent(List<DbNote?> notes) {
    return Expanded(
      child: buildListSearch(
        textSearch: listPageState.textSearch,
        notes: notes,
      ),
    );
  }

  Widget buildFloatingActionIsDeleteFalse(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildFloatingIcTrash(),
            const SizedBox(width: 24),
            buildFloatingIcAdd(context),
          ],
        ),
      ],
    );
  }

  Widget buildFloatingIcAdd(BuildContext context) {
    return Container(
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const EditNotePage(initialNote: null);
              },
            ),
          );
        },
        icon: SvgPicture.asset(AppImages.icAdd, color: Colors.white),
      ),
    );
  }

  Widget buildFloatingIcTrash() {
    return Container(
      height: AppDimens.buttonHeight,
      width: AppDimens.buttonHeight,
      decoration: BoxDecoration(
        color: AppColors.redAccent,
        borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2),
      ),
      child: IconButton(
        onPressed: () {
          listPageState.setDeleting();
        },
        icon: SvgPicture.asset(AppImages.icTrash, color: Colors.white),
      ),
    );
  }

  Widget buildFloatingActionIsDeleteTrue() {
    return Container(
      height: AppDimens.buttonHeight,
      width: AppDimens.buttonHeight,
      decoration: BoxDecoration(
        color: AppColors.redAccent,
        borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2),
      ),
      child: IconButton(
        onPressed: () {
          listPageState.setDeleting();
        },
        icon: Image.asset(
          AppImages.icDone,
          height: 24,
        ),
      ),
    );
  }

  Widget buildListSearch(
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
        return Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 18),
          child: buildCard(false, false, note: note, context: context),
        );
      },
    );
  }

  Widget buildListCard(bool? acceptDelete, bool? isDeleting,
      {required DbNote note}) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 18),
      child: buildCard(isDeleting, acceptDelete, note: note, context: context),
    );
  }

  Widget buildCard(
    bool? isDeleting,
    bool? acceptDelete, {
    required DbNote note,
    required BuildContext context,
  }) {
    return Column(
      children: [
        buildContent(note, listPageState.isDeleting),
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
                                AppImages.icClose,
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
                                AppImages.icTrash,
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
                        child: SvgPicture.asset(AppImages.icTrash, height: 24),
                      ),
                    ),
                  ))
            : const SizedBox(),
      ],
    );
  }

  Widget buildContent(DbNote note, bool isDeleting) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: isDeleting
            ? const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )
            : const BorderRadius.all(Radius.circular(8)),
      ),
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

Widget buildSearch(ListNoteProvider listPageState) {
  return Padding(
    padding: const EdgeInsets.only(top: 24),
    child: TextField(
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightBackground,
        constraints: const BoxConstraints(minHeight: 52, maxHeight: 52),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(17),
          child: SvgPicture.asset(
            AppImages.icSearch,
            height: 18,
          ),
        ),
        hintText: 'Search your note’s title here ...',
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
