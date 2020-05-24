import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';

class NotificationsApi extends ApiResource {
  NotificationsApi(ApiClient client) : super(client);

  Future<List<Notification>> getHashtagNotifications(int page) async {
    var items = await client.request('notifications', 'HashTags', named: {'page': page.toString()});
    return deserializeNotifications(items);
  }

  Future<void> readAllHashNotifs() async {
    await client.request('notifications', 'ReadHashTagsNotifications');
  }

  Future<int> getNotificationsCount() async {
    var items = await client.request('notifications', 'count');

    return items["count"];
  }

  Future<int> getHashNotificationsCount() async {
    var items = await client.request('notifications', 'HashTagscount');

    return items["count"];
  }

  Future<void> readAllDirectedNotifs() async {
    await client.request('notifications', 'ReadDirectedNotifications');
  }

  Future<List<Notification>> getNotifications(int page) async {
    var items = await client.request('notifications', 'Notifications', named: {'page': page.toString()});
    return deserializeNotifications(items);
  }
}
