import 'package:flutter/widgets.dart';
import 'package:owmflutter/content_filters/content_filters.dart';
import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/model/model.dart';

class ProfileRelatedListModel extends ListModel<ProfileRelated, ProfileRelatedModel> {
  final LoadNewItemsCallback<ProfileRelated> loadNewProfileRelateds;

  ProfileRelatedListModel({this.loadNewProfileRelateds, BuildContext context})
      : super(
            loadNewItems: (page) => OWMContentFilter.filterProfileRelated(loadNewProfileRelateds(page), context),
            mapper: (e) => ProfileRelatedModel()..setData(e));
}
