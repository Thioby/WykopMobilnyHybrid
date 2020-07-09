import 'package:flutter/foundation.dart';
import 'package:wykop_api/infrastucture/data/model/ProfileRelatedDto.dart';

class ProfileRelatedModel extends ChangeNotifier {
  int _id;
  String _url;
  String _title;
  int _voteCount;

  int get id => _id;
  String get url => _url;
  String get title => _title;
  int get voteCount => _voteCount;

  void setData(ProfileRelatedDto related) {
    _id = related.id;
    _url = related.url;
    _title = related.title;
    _voteCount = related.voteCount;
    notifyListeners();
  }
}
