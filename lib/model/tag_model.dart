import 'package:flutter/widgets.dart';
import 'package:owmflutter/main.dart';
import 'package:wykop_api/resources/tags.dart';

class TagModel extends ChangeNotifier {
  final String tag;
  TagModel(this.tag);

  bool _metaLoaded = false;

  TagMeta _tagMeta;

  bool _isObserved = false;
  bool _isBlocked = false;

  bool get isObserved => _isObserved;
  bool get isBlocked => _isBlocked;
  bool get loading => !_metaLoaded;

  String get backgroundUrl => _metaLoaded ? _tagMeta.backgroundUrl : null;

  String get description => _metaLoaded ? _tagMeta.description : '...';

  String get subHeader => _metaLoaded ? "${_tagMeta.entriesCount} wpisów • ${_tagMeta.linksCount} znalezisk" : '...';

  Future<void> loadMeta() async {
    _tagMeta = await api.tags.getMeta(tag);
    if (_tagMeta != null) {
      _metaLoaded = true;
      _isBlocked = _tagMeta.isBlocked;
      _isObserved = _tagMeta.isObserved;
      notifyListeners();
    }
  }

/*Future<void> toggleObserve() async {
    if (!_isBlocked) {
      if (_isObserved) {
        _isObserved = await api.profiles.unobserve(_fullProfile.login);
      } else {
        _isObserved = await api.profiles.observe(_fullProfile.login);
      }
    }
    notifyListeners();
  }

  Future<void> toggleBlock() async {
    if (_isBlocked) {
      _isBlocked = await api.profiles.unblock(_fullProfile.login);
    } else {
      _isBlocked = await api.profiles.block(_fullProfile.login);
    }
    notifyListeners();
  }*/
}
