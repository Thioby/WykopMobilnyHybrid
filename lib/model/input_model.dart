import 'package:flutter/cupertino.dart';
import 'package:owmflutter/widgets/input/input_bar.dart';
import 'package:wykop_api/data/model/InputData.dart';

abstract class InputModel extends ChangeNotifier {
  var inputBarKey = new GlobalKey<InputBarWidgetState>();
  Future<void> onInputSubmitted(InputData data);
}
