import 'package:flutter/material.dart';
import 'package:owmflutter/model/input_model.dart';
import 'package:owmflutter/model/model.dart';
import 'package:owmflutter/widgets/item_list.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wykop_api/data/model/ProfileRelatedDto.dart';

class ProfileRelatedList extends ItemList<ProfileRelatedDto, ProfileRelatedModel> {
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
