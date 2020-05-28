import 'package:flutter/material.dart';
import 'package:owmflutter/model/model.dart';
import 'package:owmflutter/widgets/item_list.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:wykop_api/data/model/EntryDto.dart';

class EntriesList extends ItemList<EntryDto, EntryModel> {
  EntriesList({
    ModelBuilder<EntryListModel> builder,
    Widget header,
    WidgetBuilder persistentHeaderBuilder,
  }) : super(
          builder: builder,
          persistentHeaderBuilder: persistentHeaderBuilder,
          header: header,
          buildChildren: (context) => EntryWidget(),
        );
}
