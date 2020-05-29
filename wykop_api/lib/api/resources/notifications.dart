import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/NotificationDto.dart';
import 'package:wykop_api/api/client.dart';

class NotificationsApi extends ApiResource {
  final NotificationResponseToNotificationDtoMapper _notificationDtoMapper;

  NotificationsApi(ApiClient client, this._notificationDtoMapper) : super(client);

  Future<List<NotificationDto>> getHashtagNotifications(int page) async {
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

  Future<List<NotificationDto>> getNotifications(int page) async {
    var items = await client.request('notifications', 'Notifications', named: {'page': page.toString()});
    return deserializeNotifications(items);
  }

  List<NotificationDto> deserializeNotifications(dynamic items) {
    return client.deserializeList(NotificationResponse.serializer, items).map(_notificationDtoMapper.apply).toList();
  }
}
