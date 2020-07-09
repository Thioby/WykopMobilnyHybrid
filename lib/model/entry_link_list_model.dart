import 'package:flutter/cupertino.dart';
import 'package:owmflutter/content_filters/content_filters.dart';
import 'package:wykop_api/infrastucture/data/model/EntryLinkDto.dart';
import 'model.dart';

class EntryLinkListmodel extends ListModel<EntryLinkDto, dynamic> {
  final LoadNewItemsCallback<EntryLinkDto> loadNewEntryLinks;

  EntryLinkListmodel({this.loadNewEntryLinks, BuildContext context}) // buildContext xD
      : super(
          loadNewItems: (page) => OWMContentFilter.filterEntryLinks(loadNewEntryLinks(page), context),
          mapper: (e) => e.hasEntry
              ? (EntryModel()..setData(e.entry))
              : (LinkModel()..setData(e.link)),
        );
}
