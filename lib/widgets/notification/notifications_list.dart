import 'dart:async';
import 'package:flutter/material.dart';
import 'package:owmflutter/model/model.dart';
import 'package:owmflutter/widgets/item_list.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wykop_api/infrastucture/data/model/NotificationDto.dart';

class NotificationsList extends ItemList<NotificationDto, NotificationModel> {
  NotificationsList({ModelBuilder<NotificationListModel> builder, Widget header, WidgetBuilder headerBuilder, WidgetBuilder persistentHeaderBuilder})
      : super(
          builder: builder,
          header: header,
          headerBuilder: headerBuilder,
          persistentHeaderBuilder: persistentHeaderBuilder,
          buildChildren: (context) => NotificationWidget(),
        );
}
