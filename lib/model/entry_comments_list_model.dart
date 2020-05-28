import 'package:flutter/widgets.dart';
import 'package:owmflutter/content_filters/content_filters.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'model.dart';

class EntryCommentsListModel extends ListModel<EntryCommentDto, EntryCommentModel> {
  final LoadNewItemsCallback<EntryCommentDto> loadNewComments;

  EntryCommentsListModel({this.loadNewComments, BuildContext context})
      : super(
            loadNewItems: (page) => OWMContentFilter.filterEntryComments(loadNewComments(page), context),
            mapper: (e) => EntryCommentModel()..setData(e));
}
