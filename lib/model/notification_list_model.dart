import 'package:flutter/foundation.dart';
import 'package:wykop_api/data/model/NotificationDto.dart';
import 'model.dart';
import 'package:wykop_api/api/api.dart';

class GroupedTagNotificationsModel extends ChangeNotifier {
  final String tag;
  List<NotificationModel> notifications;

  bool isExpanded = false;
  GroupedTagNotificationsModel({this.tag, this.notifications});

  void toggleExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
}

class NotificationListModel extends ListModel<NotificationDto, NotificationModel> {
  final LoadNewItemsCallback<NotificationDto> loadNewNotifications;
  int get unreadNotifsCount => this.items.where((e) => e.isNew).length;
  List<GroupedTagNotificationsModel> _grouppedNotifs = [];

  bool _canGroup = true;

  bool get canGroup => _canGroup;
  List<GroupedTagNotificationsModel> get grouppedNotifications => _grouppedNotifs;

  void updateNotifCount() {
    notifyListeners();
  }

  Future<void> loadGroupedTagNotifs() async {
    var notifCount = await api.notifications.getHashNotificationsCount();

    if (notifCount < 300) {
      _canGroup = true;

      var page = 1;
      List<NotificationDto> lastNotifsResponse;

      // Fetch all new notifs
      var notifs = List<NotificationDto>.from([]);
      do {
        lastNotifsResponse = await api.notifications.getHashtagNotifications(page);
        page++;
        notifs.addAll(lastNotifsResponse.where((e) => e.isNew));
      } while ((lastNotifsResponse ?? []).any((e) => e.isNew));

      // Group notifs by tag
      notifs.forEach((f) {
        if (!_grouppedNotifs.any((e) => e.tag == f.getTag())) {
          _grouppedNotifs.add(GroupedTagNotificationsModel(notifications: [], tag: f.getTag()));
        }

        _grouppedNotifs
            .firstWhere(
              (e) => e.tag == f.getTag(),
            )
            .notifications
            .add(
              NotificationModel()..setData(f),
            );
      });
    } else {
      _canGroup = false;
    }
    notifyListeners();
  }

  Future<void> readHashNotifs() async {
    await api.notifications.readAllHashNotifs();
    this.items.forEach((e) => e.markAsRead());
    notifyListeners();
  }

  Future<void> readDirectedNotifs() async {
    await api.notifications.readAllDirectedNotifs();
    this.items.forEach((e) => e.markAsRead());
    notifyListeners();
  }

  NotificationListModel({this.loadNewNotifications})
      : super(loadNewItems: loadNewNotifications, mapper: (e) => NotificationModel()..setData(e));
}
