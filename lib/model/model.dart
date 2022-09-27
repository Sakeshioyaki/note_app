import 'package:cv/cv.dart';
import 'package:note_app/common/app_const.dart';
import 'package:note_app/db/db.dart';

class DbNote extends DbRecord {
  final title = CvField<String>(AppConst.columnTitle);
  final content = CvField<String>(AppConst.columnContent);
  final date = CvField<int>(AppConst.columnUpdated);

  @override
  List<CvField> get fields => [id, title, content, date];
}
