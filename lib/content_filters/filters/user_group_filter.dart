import 'package:flutter/widgets.dart';
import 'package:owmflutter/content_filters/filters/filter.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:wykop_api/infrastucture/data/model/AuthorDto.dart';
import 'package:wykop_api/infrastucture/data/model/EntryCommentDto.dart';
import 'package:wykop_api/infrastucture/data/model/EntryDto.dart';
import 'package:wykop_api/infrastucture/data/model/EntryLinkDto.dart';
import 'package:wykop_api/infrastucture/data/model/LinkCommentDto.dart';
import 'package:wykop_api/infrastucture/data/model/LinkDto.dart';

class ExcludeNewbieContentFilter extends MultiTypeContentFilter {
  @override
  bool shouldEnable(BuildContext context, OWMSettings settings) {
    return settings.expandNewbieContent;
  }

  @override
  bool performFilterOnEntry(EntryDto entry) {
    return verifyAuthor(entry.author);
  }

  @override
  bool performFilterOnEntryLink(EntryLinkDto entryLink) {
    return verifyAuthor(entryLink.hasEntry ? entryLink.entry.author : entryLink.link.author);
  }

  @override
  bool performFilterOnLink(LinkDto link) {
    return verifyAuthor(link.author);
  }

  @override
  bool performFilterOnLinkComment(LinkCommentDto comment) {
    return verifyAuthor(comment.author);
  }  
  
  @override
  bool performFilterOnEntryComment(EntryCommentDto comment) {
    return verifyAuthor(comment.author);
  }
  bool verifyAuthor(AuthorDto author) => author.color != 0;
}