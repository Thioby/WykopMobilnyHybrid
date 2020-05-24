import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wykop_api/model/model.dart';
import 'package:owmflutter/models/entry.dart';
import 'package:owmflutter/models/models.dart' as prefix0;
import 'package:owmflutter/widgets/item_list.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NotificationsList extends ItemList<prefix0.Notification, NotificationModel> {
  NotificationsList({ModelBuilder<NotificationListModel> builder, Widget header, WidgetBuilder headerBuilder, WidgetBuilder persistentHeaderBuilder})
      : super(
          builder: builder,
          header: header,
          headerBuilder: headerBuilder,
          persistentHeaderBuilder: persistentHeaderBuilder,
          buildChildren: (context) => NotificationWidget(),
        );
}
