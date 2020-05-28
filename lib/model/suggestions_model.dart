import 'package:flutter/foundation.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/AuthorSuggestionDto.dart';
import 'package:wykop_api/data/model/TagSuggestionDto.dart';

class SuggestionsModel extends ChangeNotifier {
  List<TagSuggestionDto> _tagSuggestions = [];
  List<AuthorSuggestionDto> _authorSuggestions = [];

  List<TagSuggestionDto> get tagSuggestions => _tagSuggestions;
  List<AuthorSuggestionDto> get authorSuggestions => _authorSuggestions;

  Future<void> loadSuggestions(String q) async {
    if (q != null) {
      if (q.length > 3 && q.startsWith("@") && verifyAuthorSuggestion(q)) {
        var suggestions = await api.suggest.suggestUsers(q.split("@")[1]);
        _authorSuggestions = suggestions;
        _tagSuggestions = [];
        notifyListeners();
        return;
      } else if (q.length > 3 && q.startsWith("#") && verifyTagSuggestion(q)) {
        var suggestions = await api.suggest.suggestTags(q.split("#")[1]);
        _authorSuggestions = [];
        _tagSuggestions = suggestions;
        notifyListeners();
        return;
      }
    }
    clearSuggestions();
  }

  void clearSuggestions() {
    _tagSuggestions = [];
    _authorSuggestions = [];
    notifyListeners();
  }
}

// TODO: fix this regex
bool verifyAuthorSuggestion(String q) {
  return true;
  var regex = RegExp(r"^[A-Za-z0-9]+(?:[ _][A-Za-z0-9]+)*$");
  return regex.hasMatch(q);
}

// TODO: fix this regex
bool verifyTagSuggestion(String q) {
  return true;
  var regex = RegExp(r"^#\w+$");
  return regex.hasMatch(q);
}
