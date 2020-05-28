import 'package:flutter/widgets.dart';
import 'package:owmflutter/app.dart';
import 'package:owmflutter/content_filters/filters/contains_tags_filter.dart';
import 'package:owmflutter/content_filters/filters/filter.dart';
import 'package:owmflutter/content_filters/filters/user_group_filter.dart';
import 'package:owmflutter/utils/owm_settings.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/EntryLinkDto.dart';
import 'package:wykop_api/data/model/LinkCommentDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/data/model/ProfileRelatedDto.dart';

final List<MultiTypeContentFilter> filters = [
  EntryContainsTagsFilter(),
  ExcludeNewbieContentFilter(),
];

List<MultiTypeContentFilter> getEnabledFilters(BuildContext context, OWMSettings settings) {
  return filters.where((e) => e.shouldEnable(context, settings)).toList();
}

class OWMContentFilter {
  static final List<MultiTypeContentFilter> filters = [
    EntryContainsTagsFilter(),
    ExcludeNewbieContentFilter(),
  ];

  static List<MultiTypeContentFilter> getEnabledFilters(BuildContext context, OWMSettings settings) {
    return filters.where((e) => e.shouldEnable(context, settings)).toList();
  }

  static EntryDto performFilterOnEntry(EntryDto entry, BuildContext context, OWMSettings settings) {
    return entry;
    ////    return entry.rebuild(
    ////      (b) => b
    ////        ..isExpanded = getEnabledFilters(context, settings).every(
    ////          (e) => e.performFilterOnEntry(entry),
    ////        ),
    ////    );
  }

  static EntryLinkDto performFilterOnEntryLink(EntryLinkDto entry, BuildContext context, OWMSettings settings) {
    return entry;
    ////    return entry.rebuild(
    ////      (b) => b
    ////        ..isExpanded = getEnabledFilters(context, settings).every(
    ////          (e) => e.performFilterOnEntryLink(entry),
    ////        ),
    ////    );
  }

  static LinkDto performFilterOnLink(LinkDto entry, BuildContext context, OWMSettings settings) {
    return entry;
    //    return entry.rebuild(
    //      (b) => b
    //        ..isExpanded = getEnabledFilters(context, settings).every(
    //          (e) => e.performFilterOnLink(entry),
    //        ),
    //    );
  }

  static LinkCommentDto performFilterOnLinkComment(LinkCommentDto entry, BuildContext context, OWMSettings settings) {
    return entry;
    //    return entry.rebuild(
    //      (b) => b
    //        ..isExpanded = getEnabledFilters(context, settings).every(
    //          (e) => e.performFilterOnLinkComment(entry),
    //        ),
    //    );
  }

  static EntryCommentDto performFilterOnEntryComment(
      EntryCommentDto entry, BuildContext context, OWMSettings settings) {
    return entry;
    //    return entry.rebuild(
    //      (b) => b
    //        ..isExpanded = getEnabledFilters(context, settings).every(
    //          (e) => e.performFilterOnEntryComment(entry),
    //        ),
    //    );
  }

  static Future<List<EntryDto>> filterEntries(Future<List<EntryDto>> future, BuildContext context) async {
    return (await future).map((e) => performFilterOnEntry(e, context, owmSettings)).toList();
  }

  static Future<List<EntryLinkDto>> filterEntryLinks(Future<List<EntryLinkDto>> future, BuildContext context) async {
    return (await future).map((e) => performFilterOnEntryLink(e, context, owmSettings)).toList();
  }

  static ProfileRelatedDto performFilterOnProfileRelated(
      ProfileRelatedDto entry, BuildContext context, OWMSettings settings) {
    return entry;
  }

  static Future<List<EntryCommentDto>> filterEntryComments(
      Future<List<EntryCommentDto>> future, BuildContext context) async {
    return (await future).map((e) => performFilterOnEntryComment(e, context, owmSettings)).toList();
  }

  static Future<List<LinkDto>> filterLinks(Future<List<LinkDto>> future, BuildContext context) async {
    return (await future).map((e) => performFilterOnLink(e, context, owmSettings)).toList();
  }

  static Future<List<LinkCommentDto>> filterLinkComments(
      Future<List<LinkCommentDto>> future, BuildContext context) async {
    return (await future).map((e) => performFilterOnLinkComment(e, context, owmSettings)).toList();
  }

  static Future<List<ProfileRelatedDto>> filterProfileRelated(
      Future<List<ProfileRelatedDto>> future, BuildContext context) async {
    return (await future).map((e) => performFilterOnProfileRelated(e, context, owmSettings)).toList();
  }
}

class EntryContentFilter extends ContentFilter<EntryDto> {
  @override
  EntryDto filter(EntryDto item, BuildContext context, OWMSettings settings) {
    return item;
    //    return item.rebuild(
    //      (b) => b
    //        ..isExpanded = getEnabledFilters(context, settings).every(
    //          (e) => e.performFilterOnEntry(item),
    //        ),
    //    );
  }

  @override
  Future<List<EntryDto>> filterFutureList(Future<List<EntryDto>> future, BuildContext context) async {
    return (await future).map((e) => this.filter(e, context, owmSettings)).toList();
  }
}

abstract class ContentFilter<T> {
  Future<List<T>> filterFutureList(Future<List<T>> future, BuildContext context);

  T filter(T item, BuildContext context, OWMSettings settings);
}
