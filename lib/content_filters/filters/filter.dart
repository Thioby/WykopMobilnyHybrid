import 'package:flutter/cupertino.dart';
import 'package:owmflutter/utils/utils.dart';

import 'package:wykop_api/infrastucture/data/model/EntryCommentDto.dart';
import 'package:wykop_api/infrastucture/data/model/EntryDto.dart';
import 'package:wykop_api/infrastucture/data/model/EntryLinkDto.dart';
import 'package:wykop_api/infrastucture/data/model/LinkCommentDto.dart';
import 'package:wykop_api/infrastucture/data/model/LinkDto.dart';
import 'package:wykop_api/infrastucture/data/model/ProfileRelatedDto.dart';

abstract class ContentFilter<T> {
  Future<void> setup(BuildContext context, OWMSettings settings);
  Future<bool> performFilter<T>();
}

abstract class MultiTypeContentFilter {
  bool shouldEnable(BuildContext context, OWMSettings settings);
  
  bool performFilterOnLink(LinkDto entry) => true;
  bool performFilterOnEntry(EntryDto entry) => true;
  bool performFilterOnEntryLink(EntryLinkDto entry) => true;
  bool performFilterOnEntryComment(EntryCommentDto entryComment) => true;
  bool performFilterOnLinkComment(LinkCommentDto entry) => true;
  bool performFilterOnProfileRelated(ProfileRelatedDto related) => true;

}