import 'package:flutter/widgets.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';

class ProfileModel extends ChangeNotifier {
  AuthorDto author;
  ProfileModel(this.author);

  // TODO ??
  factory ProfileModel.fromUsername(String username) =>
      ProfileModel(AuthorDto(login: username));

  bool _profileLoaded = false;

  ProfileResponse _fullProfile;

  bool _isObserved = false;
  bool _isBlocked = false;

  String _violationUrl;

  bool get isObserved => _isObserved;
  bool get isBlocked => _isBlocked;
  bool get isFullyLoaded => _fullProfile != null;

  String get backgroundUrl => _fullProfile.background;
  String get about => _fullProfile.about;

  String get violationUrl => _violationUrl;

  // TODO :|
  String get formattedDate => _profileLoaded ? "Dołączył/a ${Utils.getSimpleDate(_fullProfile.signupAt)}" : '...';


  String get formatttedRankAndObservers => _profileLoaded ? formatRankAndObservers() : '...';

  String formatRankAndObservers() {
    var prefix = "";
    if (_fullProfile.rank > 0) {
      prefix += "#${_fullProfile.rank.toString()} • ";
    }

    prefix += "${_fullProfile.followers.toString()} ${Utils.polishPlural(
      count: _fullProfile.followers,
      first: "obserwujący",
      many: "obserwujących",
      other: "obserwujących",
    )}";
    return prefix;
  }

  Future<void> loadFullProfile() async {
    _fullProfile = await api.profiles.getProfile(author.login);
    if (_fullProfile != null) {
      _profileLoaded = true;
      _isBlocked = _fullProfile.isBlocked;
      _isObserved = _fullProfile.isObserved;
      _violationUrl = _fullProfile.violationUrl;
      author = AuthorDto(login: _fullProfile.login, color: _fullProfile.color, avatar: _fullProfile.avatarUrl);

      notifyListeners();
    }
  }

  Future<void> toggleObserve() async {
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
  }
}
