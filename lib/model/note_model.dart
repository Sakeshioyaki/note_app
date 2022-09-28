const String tableTodo = 'todo';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnContent = 'content';
const String columnTime = 'time';

class DbNoteModel {
  String title;
  int id;
  String content;
  String time;

  DbNoteModel({
    String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnId: id,
      columnTitle: title,
      columnContent: content,
      columnTime: time
    };
    return map;
  }

  DbNoteModel();
  DbNoteModel.fromMap(Map<String, Object?> map) {
    id = int.parse(map[columnId]);
    title = map[columnTitle];
    content = map[columncontent];
    time = map[columnTime] == 1;
  }
}
