import 'package:flutter/widgets.dart';
import 'package:owmflutter/content_filters/content_filters.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'model.dart';

class EntryListModel extends ListModel<EntryDto, EntryModel> {
  final LoadNewItemsCallback<EntryDto> loadNewEntries;

  EntryListModel({this.loadNewEntries, BuildContext context})
      : super(
            loadNewItems: (page) => OWMContentFilter.filterEntries(loadNewEntries(page), context),
            mapper: (e) => EntryModel()..setData(e));
}
