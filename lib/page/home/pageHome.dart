import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
import 'package:note_app/common/app_images.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/controller/auth_controller.dart';
import 'package:note_app/controller/note_controller.dart';
import 'package:note_app/controller/user_controller.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/page/home/home_controller.dart';
import 'package:note_app/page/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  UserController userController = Get.put<UserController>(UserController());
  HomeController homeController = Get.put<HomeController>(HomeController());
  NoteController noteController = Get.put<NoteController>(NoteController());
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetX<UserController>(
          builder: (_) {
            if (_.user.name != null) {
              return Text("Welcome ${_.user.name}");
            } else {
              return const Text("loading...");
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              authController.signOut();
              Get.to(() => LoginPage());
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scaffold(
      body: buildMyNote(),
      floatingActionButton: homeController.isSearching.value
          ? const SizedBox()
          : homeController.isDeleting.value
              ? buildFloatingActionIsDeleteTrue()
              : buildFloatingActionIsDeleteFalse(context),
    );
  }

  Widget buildMyNote() {
    if (noteController.noteList.value == []) {
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
                buildSearch(),
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
          homeController.isSearching.value
              ? buildSearchContent()
              : buildListCardNote(),
        ],
      ),
    );
  }

  Widget buildListCardNote() {
    return Expanded(
      child: ListView.builder(
        itemCount: noteController.noteList.value.length,
        itemBuilder: (context, index) {
          return buildListCard(index);
        },
      ),
    );
  }

  Widget buildSearchContent() {
    return Expanded(
      child: buildListSearch(),
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
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return const EditNotePage(initialNote: null);
          //     },
          //   ),
          // );
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
          homeController.setDeleting();
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
          homeController.setDeleting();
        },
        icon: Image.asset(
          AppImages.icDone,
          height: 24,
        ),
      ),
    );
  }

  Widget buildListSearch() {
    final notes = noteController.noteList.value;
    List<NoteModel?> resultSearch = [];
    for (var e in notes) {
      if (e.title!.contains(homeController.textSearch.value) ||
          e.content!.contains(homeController.textSearch.value)) {
        resultSearch.add(e);
      }
    }
    return ListView.builder(
      itemCount: resultSearch.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 18),
          child: buildCard(index),
        );
      },
    );
  }

  Widget buildListCard(index) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 18),
      child: buildCard(index),
    );
  }

  Widget buildCard(int index) {
    bool acceptDelete = false;
    for (var element in homeController.listIdDeleting) {
      if (element.value == noteController.noteList.value[index].id) {
        (acceptDelete = true);
      }
    }
    return Column(
      children: [
        buildContent(index),
        (homeController.isDeleting.value)
            ? (acceptDelete == true
                ? SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              homeController.removeListDeleting(
                                  noteController.noteList.value[index].id);
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
                              await noteController.deleteNote(
                                  noteController.noteList.value[index].id!,
                                  userController.user.id);
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
                      homeController.addListDeleting(
                          noteController.noteList.value[index].id);
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

  Widget buildContent(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: homeController.isDeleting.value
            ? const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )
            : const BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          //   return NotePage(
          //     noteId: noteController.noteList.value[index].id!,
          //   );
          // }));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noteController.noteList.value[index].title ?? '',
                style: AppTextStyle.textDarkPrimaryS18,
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                LineSplitter.split(
                        noteController.noteList.value[index].content!)
                    .first,
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

  Widget buildSearch() {
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
          if (homeController.isSearching.value) {
            homeController.setSearching();
          }
          if (text == '') {
            homeController.setSearching();
          } else {
            homeController.setTextSearch(text);
          }
        },
      ),
    );
  }
}
