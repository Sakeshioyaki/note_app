import 'package:cv/cv.dart';
import 'package:note_app/model/model_constant.dart';

abstract class DbRecord extends CvModelBase {
  final id = CvField<int>(columnId);
}
