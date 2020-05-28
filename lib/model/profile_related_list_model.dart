import 'package:flutter/widgets.dart';
import 'package:owmflutter/content_filters/content_filters.dart';
import 'package:wykop_api/data/model/ProfileRelatedDto.dart';
import 'model.dart';

class ProfileRelatedListModel extends ListModel<ProfileRelatedDto, ProfileRelatedModel> {
  final LoadNewItemsCallback<ProfileRelatedDto> loadNewProfileRelateds;

  ProfileRelatedListModel({this.loadNewProfileRelateds, BuildContext context})
      : super(
            loadNewItems: (page) => OWMContentFilter.filterProfileRelated(loadNewProfileRelateds(page), context),
            mapper: (e) => ProfileRelatedModel()..setData(e));
}
