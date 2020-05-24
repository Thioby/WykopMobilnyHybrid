import 'package:flutter/material.dart';
import 'package:wykop_api/model/model.dart';
import 'package:owmflutter/models/entry.dart';
import 'package:owmflutter/widgets/item_list.dart';
import 'package:owmflutter/widgets/widgets.dart';

class EntriesList extends ItemList<Entry, EntryModel> {
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
