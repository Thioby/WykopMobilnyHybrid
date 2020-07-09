import 'package:flutter/foundation.dart';
import 'package:wykop_api/infrastucture/data/model/dtoModels.dart';

class NotificationModel extends ChangeNotifier {
  int _id;
  String _body;
  String _date;
  String _itemId;
  String _url;
  String _type;
  bool _isNew;
  AuthorDto _author;

  int get id => _id;
  String get body => _body;
  String get date => _date;
  String get itemId => _itemId;
  String get url => _url;
  String get type => _type;
  bool get isNew => _isNew;
  AuthorDto get author => _author;

  void setData(NotificationDto notification) {
    _id = notification.id;
    _body = notification.body;
    _date = notification.date;
    _itemId = notification.itemId;
    _url = notification.url;
    _type = notification.type;
    _isNew = notification.isNew;
    _author = notification.author;

    notifyListeners();
  }

  void markAsRead() {
    _isNew = false;
    notifyListeners();
  }
}
