import 'package:flutter/cupertino.dart';
import 'package:owmflutter/content_filters/content_filters.dart';
import 'package:wykop_api/data/model/LinkCommentDto.dart';
import 'model.dart';

class LinkCommentListModels extends ListModel<LinkCommentDto, LinkCommentModel> {
  final LoadNewItemsCallback<LinkCommentDto> loadNewLinkComments;

  LinkCommentListModels({this.loadNewLinkComments, BuildContext context})
      : super(
            loadNewItems: (page) => OWMContentFilter.filterLinkComments(loadNewLinkComments(page), context),
            mapper: (e) => LinkCommentModel()..setData(e));
}
