import 'package:flutter/material.dart';
import 'package:owmflutter/api/api.dart';
import 'package:owmflutter/model/model.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:owmflutter/owm_glyphs.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShadowControlModel>(
      builder: (context) => ShadowControlModel(scrollDelayPixels: 4),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppbarTabsWidget(
            tabs: <Widget>[
              Tab(text: "Wiadomości"),
              Tab(text: "Powiadomienia"),
              Tab(text: "Tagi"),
            ],
          ),
          body: TabBarView(
            children: [
              NotLoggedWidget(
                icon: Icons.mail,
                text: "Prywatne wiadomości",
                child: ConversationsList(),
              ),
              NotLoggedWidget(
                icon: Icons.notifications,
                text: "Powiadomienia",
                child: NotificationsList(
                  header: _header(
                    context: context,
                    count: 0, //TODO: implement num notifications
                    markRead: () {
                      //TODO: implement mark read notifications
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Niezaimplementowane")));
                    },
                  ),
                  builder: (context) => NotificationListModel(
                    loadNewNotifications: (page) =>
                        api.notifications.getNotifications(page),
                  ),
                ),
              ),
              NotLoggedWidget(
                icon: OwmGlyphs.ic_navi_my_wykop,
                text: "Obserwowane tagi",
                child: NotificationsList(
                  header: _header(
                    context: context,
                    count: 0, //TODO: implement num hashtag notifications
                    markRead: () {
                      //TODO: implement mark read hashtag notifications
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Niezaimplementowane")));
                    },
                    group: () {
                      //TODO: implement group hashtag notifications
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Niezaimplementowane")));
                    },
                    isGroup:
                        false, //TODO: implement state hashtag notifications
                  ),
                  builder: (context) => NotificationListModel(
                    loadNewNotifications: (page) =>
                        api.notifications.getHashtagNotifications(page),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header({
    BuildContext context,
    num count,
    VoidCallback markRead,
    VoidCallback group,
    bool isGroup: false,
  }) {
    return Container(
      padding: EdgeInsets.only(
        top: 6.0,
        bottom: 10.0,
        left: 18.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Nieodczytane: $count",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.body1.color,
            ),
          ),
          Row(
            children: <Widget>[
              Visibility(
                visible: group != null,
                child: Tooltip(
                  message: isGroup
                      ? "Nie grupuj powiadomień"
                      : "Grupuj powiadomienia",
                  child: RoundIconButtonWidget(
                    icon: isGroup
                        ? Icons.format_list_numbered
                        : Icons.format_list_bulleted,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    onTap: markRead,
                  ),
                ),
              ),
              Tooltip(
                message: "Oznacz jako odczytane",
                child: RoundIconButtonWidget(
                  icon: OwmGlyphs.ic_mark_read,
                  padding: EdgeInsets.all(0.0),
                  onTap: group,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
