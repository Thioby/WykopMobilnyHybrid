import 'package:flutter/material.dart';
import 'package:wykop_api/model/model.dart';
import 'package:owmflutter/models/models.dart';
import 'package:owmflutter/widgets/item_list.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProfileRelatedList extends ItemList<ProfileRelated, ProfileRelatedModel> {
  ProfileRelatedList(
      {ModelBuilder<ProfileRelatedListModel> builder,
      Widget header,
      WidgetBuilder persistentHeaderBuilder})
      : super(
          builder: builder,
          persistentHeaderBuilder: persistentHeaderBuilder,
          header: header,
          buildChildren: (context) => ChangeNotifierProvider<InputModel>(
            create: (context) => FakeInputModel(),
            child: ProfileRelatedWidget(),
          ),
        );
}
