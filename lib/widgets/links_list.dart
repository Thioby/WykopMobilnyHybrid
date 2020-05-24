import 'package:flutter/material.dart';
import 'package:wykop_api/model/model.dart';
import 'package:owmflutter/models/link.dart';
import 'package:owmflutter/utils/owm_settings.dart';
import 'package:owmflutter/widgets/item_list.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LinksList extends ItemList<Link, LinkModel> {
  LinksList({ModelBuilder<LinkListModel> builder, Widget header, WidgetBuilder persistentHeaderBuilder})
      : super(
          builder: builder,
          persistentHeaderBuilder: persistentHeaderBuilder,
          header: header,
          buildChildren: (context) =>
              Provider.of<OWMSettings>(context, listen: false).simpleLinkView
                  ? LinkSimpleWidget()
                  : LinkWidget(),
        );
}
