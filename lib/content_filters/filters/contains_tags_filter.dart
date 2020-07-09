import 'package:flutter/widgets.dart';
import 'package:owmflutter/content_filters/filters/filter.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:wykop_api/infrastucture/data/model/EntryDto.dart';

class EntryContainsTagsFilter extends MultiTypeContentFilter {
  var tagsRegex = RegExp("(^|\\s)(#[a-z\\d-]+)");

  @override
  bool shouldEnable(BuildContext context, OWMSettings settings) {
    return settings.expandNoTagContent;
  }

  @override
  bool performFilterOnEntry(EntryDto entry) {
    return tagsRegex.hasMatch(removeAllHtmlTags(entry.body ?? ""));
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }
}