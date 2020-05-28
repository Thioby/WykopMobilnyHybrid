import 'package:owmflutter/model/link_comment_model.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/InputData.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/data/model/RelatedDto.dart';
import 'input_model.dart';

class LinkModel extends InputModel {
  @override
  Future<void> onInputSubmitted(InputData data) async {
    var newComm;
    if (!isResponding) {
      newComm = await api.links.addComment(_id, data);
      _comments.add(LinkCommentModel()..setData(newComm));
    } else {
      newComm = await api.links.addComment(_id, data, commentId: _respondingTo);
      var comm = _comments.lastWhere((e) => e.parentId == _respondingTo);
      _comments.insert(_comments.indexOf(comm) + 1, LinkCommentModel()..setData(newComm));
    }
    _commentsCount = comments.length;
    cancelReply();
    // loadComments();
  }

  void updateLink() async {
    setData(await api.links.getLink(_id));
  }

  void replyTo(AuthorDto author, int parentId) {
    _respondingTo = parentId;
    // TODO WTF???
    inputBarKey.currentState.replyToUser(author);  // WTF?
    notifyListeners();
  }

  void cancelReply() {
    _respondingTo = -1;
    notifyListeners();
  }

  int _id;
  String _title;
  bool _isExpanded;
  String _description;
  String _tags;
  String _sourceUrl;
  int _relatedCount;
  String _preview;
  bool _isHot;
  bool _canVote;
  String _date;
  int _voteCount;
  AuthorDto _author;
  int _commentsCount;
  int _buryCount;
  List<RelatedDto> _relatedLinks;
  LinkVoteState _voteState;
  bool _isFavorite;
  List<LinkCommentModel> _comments = [];
  String _violationUrl;
  String _app;

  int _respondingTo = -1;

  bool get isResponding => _respondingTo != -1;
  AuthorDto get respondingTo => _comments.firstWhere((e) => e.id == _respondingTo).author;
  int get id => _id;
  String get date => _date;
  int get voteCount => _voteCount;
  int get buryCount => _buryCount;
  AuthorDto get author => _author;
  String get title => (_title ?? "").replaceAll('&quot;', '"').replaceAll('&amp;', '&');
  String get description => _description.replaceAll('&quot;', '"').replaceAll('&amp;', '&');
  String get sourceUrl => _sourceUrl;
  String get tags => _tags;
  int get relatedCount => _relatedCount;
  String get preview => _preview;
  List<RelatedDto> get relatedLinks => _relatedLinks;
  bool get isHot => _isHot;
  bool get isFavorite => _isFavorite;
  bool get isExpanded => _isExpanded;
  bool get canVote => _canVote;
  String get violationUrl => _violationUrl;
  String get app => _app;

  int get commentsCount => _commentsCount;
  LinkVoteState get voteState => _voteState;
  List<LinkCommentModel> get comments => _comments;
  bool get isLoading => _title == null;
  void expand() {
    _isExpanded = true;
    notifyListeners();
  }

  void setData(LinkDto link) {
    _id = link.id;
    _date = link.date;
    _voteCount = link.voteCount;
    _author = link.author;
    _description = link.description;
    _isExpanded = link.isExpanded;
    _title = link.title;
    _sourceUrl = link.sourceUrl;
    _tags = link.tags;
    _buryCount = link.buryCount;
    _relatedCount = link.relatedCount;
    _preview = link.preview;
    _isHot = link.isHot;
    _isFavorite = link.isFavorite;
    _canVote = link.canVote;
    _relatedLinks = [];
    _voteState = link.voteState;
    _comments = [];
    _commentsCount = link.commentsCount;
    _violationUrl = link.violationUrl;
    _app = link.app;
    notifyListeners();
  }

  void setId(int id) {
    _id = id;
  }

  void favoriteToggle() async {
    _isFavorite = await api.entries.markFavorite(_id);
    notifyListeners();
  }

  Future<void> loadComments() async {
    var allComents = await api.links.getLinkComments(id);
    _comments = allComents.map((e) => LinkCommentModel()..setData(e)).toList();
    /*.where((e) => e.id == e.parentId)
      ..forEach(
        (c) {
          c.children.addAll(
            allComents.where((e) => e.parentId == c.id && e.id != c.id),
          );
        },
      );*/
    _relatedLinks = await api.links.getRelatedLinks(id);
    notifyListeners();
  }

  Future<void> voteUp() async {
    if (_voteState != LinkVoteState.NONE) {
      return voteRemove();
    }

    var res = await api.links.voteUp(_id.toString());
    _buryCount = res.buries;
    _voteCount = res.digs;
    _voteState = res.state;
    notifyListeners();
  }

  Future<void> voteDown(int reason) async {
    if (_voteState != LinkVoteState.NONE) {
      return voteRemove();
    }
    var res = await api.links.voteDown(_id.toString(), reason);
    _buryCount = res.buries;
    _voteCount = res.digs;
    _voteState = res.state;
    notifyListeners();
  }

  Future<void> voteRemove() async {
    var res = await api.links.voteRemove(_id.toString());
    _buryCount = res.buries;
    _voteCount = res.digs;
    _voteState = res.state;
    notifyListeners();
  }
}
