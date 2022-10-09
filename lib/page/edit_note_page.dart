// import 'package:flutter/material.dart';
// import 'package:note_app/controller/note_controller.dart';
// import 'package:note_app/model/note_model.dart';
//
// class EditNotePage extends StatefulWidget {
//   final NoteModel? initialNote;
//
//   const EditNotePage({Key? key, required this.initialNote}) : super(key: key);
//   @override
//   EditNotePageState createState() => EditNotePageState();
// }
//
// class EditNotePageState extends State<EditNotePage> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController? _titleTextController;
//   TextEditingController? _contentTextController;
//
//   String? get _noteId => widget.initialNote?.id;
//   @override
//   void initState() {
//     super.initState();
//     _titleTextController =
//         TextEditingController(text: widget.initialNote?.title);
//     _contentTextController =
//         TextEditingController(text: widget.initialNote?.content);
//   }
//
//   Future save() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       NoteController.createNote(NoteModel()
//         ..id.v = _noteId
//         ..title.v = _titleTextController?.text
//         ..content.v = _contentTextController?.text
//         ..date.v = DateTime.now().millisecondsSinceEpoch);
//       Navigator.pop(context);
//       if (_noteId != null) {
//         Navigator.pop(context);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: editPageState.needAcceptStream,
//       builder: (cont, snapshot) {
//         return Scaffold(
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: buildBody(),
//           ),
//           floatingActionButton: buildFloatAction(),
//         );
//       },
//     );
//   }
//
//   Widget buildBody() {
//     return ListView(
//       children: <Widget>[
//         Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               TextFormField(
//                 decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Write title here ...',
//                     hintStyle: AppTextStyle.textLightPlaceholder),
//                 controller: _titleTextController,
//                 style: AppTextStyle.textDarkPrimaryS24Bold,
//                 validator: (val) =>
//                     val!.isNotEmpty ? null : 'Title must not be empty',
//               ),
//               Text(
//                 DateFormat('dd MMM y    h:mm a').format(DateTime.now()),
//                 style: AppTextStyle.textLightPlaceholderS12,
//               ),
//               TextFormField(
//                 textAlign: TextAlign.start,
//                 decoration: const InputDecoration(
//                   hintText: 'Write content here ...',
//                   hintStyle: AppTextStyle.textLightPlaceholder,
//                   contentPadding: EdgeInsets.all(10.0),
//                   border: InputBorder.none,
//                 ),
//                 controller: _contentTextController,
//                 validator: (val) =>
//                     val!.isNotEmpty ? null : 'Description must not be empty',
//                 keyboardType: TextInputType.multiline,
//                 maxLines: 5,
//                 style: AppTextStyle.textDarkPrimaryS14,
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildFloatAction() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           btnBack(),
//           editPageState.needAccept
//               ? buildFloatingNeedAcceptTrue()
//               : buildFloatingNeedAcceptFalse(),
//         ],
//       ),
//     );
//   }
//
//   Widget buildFloatingNeedAcceptFalse() {
//     return Container(
//       height: AppDimens.buttonHeight,
//       width: AppDimens.buttonHeight,
//       decoration: BoxDecoration(
//         color: AppColors.greenAccent,
//         borderRadius: BorderRadius.circular(
//           AppDimens.buttonHeight / 2,
//         ),
//       ),
//       child: IconButton(
//         onPressed: () {
//           save();
//         },
//         icon: Image.asset(
//           AppImages.icSave,
//           width: 24,
//         ),
//       ),
//     );
//   }
//
//   Widget buildFloatingNeedAcceptTrue() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Container(
//           height: AppDimens.buttonHeight,
//           width: AppDimens.buttonHeight,
//           decoration: BoxDecoration(
//             color: AppColors.greenAccent,
//             borderRadius: BorderRadius.circular(
//               AppDimens.buttonHeight / 2,
//             ),
//           ),
//           child: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             icon: Image.asset(
//               AppImages.icCancel,
//               height: 24,
//             ),
//           ),
//         ),
//         const SizedBox(width: 24),
//         Container(
//           height: AppDimens.buttonHeight,
//           width: AppDimens.buttonHeight,
//           decoration: BoxDecoration(
//             color: AppColors.redAccent,
//             borderRadius: BorderRadius.circular(
//               AppDimens.buttonHeight / 2,
//             ),
//           ),
//           child: IconButton(
//             onPressed: () {
//               save();
//             },
//             icon: Image.asset(
//               AppImages.icDone,
//               height: 24,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget btnBack() {
//     return Container(
//       height: AppDimens.buttonHeight,
//       width: AppDimens.buttonHeight,
//       decoration: BoxDecoration(
//         color: AppColors.darkPrimary,
//         borderRadius: BorderRadius.circular(
//           AppDimens.buttonHeight / 2,
//         ),
//       ),
//       child: IconButton(
//         onPressed: () async {
//           var dirty = false;
//           if ((_titleTextController!.text != widget.initialNote?.title.v) &&
//               (_titleTextController!.text != 'Write title here ...')) {
//             dirty = true;
//           } else if ((_contentTextController!.text !=
//                   widget.initialNote?.content.v) &&
//               (_contentTextController!.text != 'Write content here ...')) {
//             dirty = true;
//           }
//           if (dirty) {
//             editPageState.setAccept();
//           } else {
//             Navigator.of(context).pop(false);
//           }
//         },
//         icon: SvgPicture.asset(AppImages.icBack),
//       ),
//     );
//   }
// }
