import 'package:flutter/foundation.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryMediaDto.dart';
import 'package:wykop_api/data/model/VoterDto.dart';

class EntryCommentModel extends ChangeNotifier {
  int _id;
  String _body;
  String _date;
  int _voteCount;
  AuthorDto _author;
  EntryMediaDto _embed;
  bool _isVoted;
  bool _isExpanded;
  List<VoterDto> _upvoters = [];
  String _violationUrl;
  String _app;

  int get id => _id;
  String get body => _body;
  String get date => _date;
  int get voteCount => _voteCount;
  AuthorDto get author => _author;
  EntryMediaDto get embed => _embed;
  bool get isExpanded => _isExpanded;
  bool get isVoted => _isVoted;
  String get violationUrl => _violationUrl;
  String get app => _app;

  List<VoterDto> get upvoters => _upvoters.reversed.toList();

  void expand() {
    _isExpanded = true;
    notifyListeners();
  }

  void setData(EntryCommentDto comment) {
    _id = comment.id;
    _body = comment.body;
    _date = comment.date;
    _voteCount = comment.voteCount;
    _author = comment.author;
    _embed = comment.embed;
    _isVoted = comment.isVoted;
    _isExpanded = comment.isExpanded;
    _violationUrl = comment.violationUrl;
    _app = comment.app;
    notifyListeners();
  }

  Future<void> delete() async {
    await api.entries.deleteComment(_id);
    _body = "[Komentarz usunięty]";
    notifyListeners();
  }

  Future<void> loadUpVoters() async {
    _upvoters = await api.entries.getEntryCommentUpVoters(_id);
    notifyListeners();
  }

  Future<void> toggleVote() async {
    if (!_isVoted) {
      _voteCount = await api.entries.voteComemntUp(_id);
      _isVoted = true;
    } else {
      _voteCount = await api.entries.voteCommentDown(_id);
      _isVoted = false;
    }
    notifyListeners();
  }
}
