// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:note_app/controller/auth_controller.dart';
// import 'package:note_app/controller/user_controller.dart';
// import 'package:note_app/db/db.dart';
//
// class NotePage extends StatefulWidget {
//   final String noteId;
//
//   const NotePage({Key? key, required this.noteId}) : super(key: key);
//
//   @override
//   NotePageState createState() => NotePageState();
// }
//
// class NotePageState extends State<NotePage> {
//   late bool isEditing = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: GetX<UserController>(
//           initState: (_) async {
//             Get.find<UserController>().user =
//                 await Database().getUser(Get.find<AuthController>().user!.uid);
//           },
//           builder: (_) {
//             if (_.user.name != null) {
//               return Text("Welcome  + ${_.user.name}");
//             } else {
//               return Text("loading...");
//             }
//           },
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: () {
//               controller.signOut();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               if (Get.isDarkMode) {
//                 Get.changeTheme(ThemeData.light());
//               } else {
//                 Get.changeTheme(ThemeData.dark());
//               }
//             },
//           )
//         ],
//       ),
//       body: Stack(children: [
//         ListView(children: [
//           ListTile(
//               title: Text(
//             note.title.v!,
//             style: AppTextStyle.textDarkPrimaryS24Bold,
//           )),
//           ListTile(
//             title: Text(
//               DateFormat('dd MMM y    h:mm a').format(DateTime.now()),
//               style: AppTextStyle.textLightPlaceholderS12,
//             ),
//           ),
//           ListTile(
//               title: Text(
//             note.content.v ?? '',
//             style: AppTextStyle.textDarkPrimaryS14,
//           )),
//         ]),
//       ]),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               SizedBox(width: 40),
//               Container(
//                 height: AppDimens.buttonHeight,
//                 width: AppDimens.buttonHeight,
//                 decoration: BoxDecoration(
//                   color: AppColors.darkPrimary,
//                   borderRadius:
//                       BorderRadius.circular(AppDimens.buttonHeight / 2),
//                 ),
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: SvgPicture.asset(
//                     AppImages.icBack,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Container(
//                 height: AppDimens.buttonHeight,
//                 width: AppDimens.buttonHeight,
//                 decoration: BoxDecoration(
//                     color: AppColors.redAccent,
//                     borderRadius:
//                         BorderRadius.circular(AppDimens.buttonHeight / 2)),
//                 child: IconButton(
//                   onPressed: () async {
//                     if (await showDialog<bool>(
//                             context: context,
//                             barrierDismissible: false, // user must tap button!
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text('Delete note?'),
//                                 content: SingleChildScrollView(
//                                   child: ListBody(
//                                     children: const <Widget>[
//                                       Text(
//                                         'Tap \'YES\' to confirm note deletion.',
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(true);
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(builder: (context) {
//                                           return ListNotePage();
//                                         }),
//                                       );
//                                     },
//                                     child: Text('YES'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(false);
//                                     },
//                                     child: Text('NO'),
//                                   ),
//                                 ],
//                               );
//                             }) ??
//                         false) {}
//                   },
//                   icon: SvgPicture.asset(
//                     AppImages.icTrash,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 24),
//               Container(
//                 height: AppDimens.buttonHeight,
//                 width: AppDimens.buttonHeight,
//                 decoration: BoxDecoration(
//                   color: AppColors.greenAccent,
//                   borderRadius: BorderRadius.circular(
//                     AppDimens.buttonHeight / 2,
//                   ),
//                 ),
//                 child: IconButton(
//                   onPressed: () {},
//                   icon: SvgPicture.asset(AppImages.icEdit),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
