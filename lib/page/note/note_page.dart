import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_dimens.dart';
import 'package:note_app/common/app_images.dart';
import 'package:note_app/common/app_text_styles.dart';
import 'package:note_app/controller/note_controller.dart';
import 'package:note_app/controller/user_controller.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/page/edit_note/edit_note_page.dart';
import 'package:note_app/page/home/pageHome.dart';

class NotePage extends StatefulWidget {
  final NoteModel? note;

  const NotePage({Key? key, this.note}) : super(key: key);

  @override
  NotePageState createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  late bool isEditing = false;
  NoteController noteController = Get.find<NoteController>();
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteController>(
      builder: (_) {
        void edit() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EditNotePage(
                  initialNote: widget.note,
                );
              },
            ),
          );
        }

        return Scaffold(
          body: Stack(children: [
            ListView(children: [
              ListTile(
                  title: Text(
                widget.note?.title ?? '',
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
                widget.note?.content ?? '',
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
                                              return HomePage();
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
                          await noteController.deleteNote(
                              widget.note!.id!, userController.user.id);
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
