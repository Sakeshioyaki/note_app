import 'package:cv/cv.dart';
import 'package:note_app/common/app_const.dart';

abstract class DbRecord extends CvModelBase {
  final id = CvField<int>(AppConst.columnId);
}
