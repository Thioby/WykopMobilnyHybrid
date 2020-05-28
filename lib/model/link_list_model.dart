import 'package:flutter/widgets.dart';
import 'package:owmflutter/content_filters/content_filters.dart';
import 'package:owmflutter/model/model.dart';
import 'package:wykop_api/data/model/LinkDto.dart';

class LinkListModel extends ListModel<LinkDto, LinkModel> {
  final LoadNewItemsCallback<LinkDto> loadNewLinks;

  LinkListModel({this.loadNewLinks, BuildContext context})
      : super(
            loadNewItems: (page) => OWMContentFilter.filterLinks(loadNewLinks(page), context),
            mapper: (e) => LinkModel()..setData(e));
}
