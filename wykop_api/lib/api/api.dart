import 'dart:async' show Future;
import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:wykop_api/api/client.dart';
import 'package:wykop_api/api/resources/embed.dart';
import 'package:wykop_api/api/resources/entries.dart';
import 'package:wykop_api/api/resources/links.dart';
import 'package:wykop_api/api/resources/mywykop.dart';
import 'package:wykop_api/api/resources/notifications.dart';
import 'package:wykop_api/api/resources/pm.dart';
import 'package:wykop_api/api/resources/profiles.dart';
import 'package:wykop_api/api/resources/search.dart';
import 'package:wykop_api/api/resources/suggest.dart';
import 'package:wykop_api/api/resources/tags.dart';
import 'package:wykop_api/api/resources/users.dart';
import 'package:wykop_api/injection/Injector.dart';
import 'package:wykop_api/injection/api/api_injection.dart';
import 'package:wykop_api/injection/api/mappers_injection.dart';

export 'resources/api_resource.dart';
export 'resources/embed.dart';
export 'resources/entries.dart';
export 'resources/links.dart';
export 'resources/mywykop.dart';
export 'resources/notifications.dart';
export 'resources/pm.dart';
export 'resources/profiles.dart';
export 'resources/search.dart';
export 'resources/suggest.dart';
export 'resources/tags.dart';
export 'resources/users.dart';
export 'response_models/author_response.dart';
export 'response_models/author_suggestion_response.dart';
export 'response_models/conversation_response.dart';
export 'response_models/embed_response.dart';
export 'response_models/entry_comment_response.dart';
export 'response_models/entry_link_response.dart';
export 'response_models/entry_response.dart';
export 'response_models/link_comment_response.dart';
export 'response_models/link_response.dart';
export 'response_models/notification_response.dart';
export 'response_models/pm_message_response.dart';
export 'response_models/profile_related_response.dart';
export 'response_models/profile_response.dart';
export 'response_models/related_response.dart';
export 'response_models/serializers.dart';
export 'response_models/tag_suggestion_response.dart';

String generateMd5(String data) {
  var content = Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);

  return hex.encode(digest.bytes);
}


class WykopApiClient {
  final ApiClient _client;

  StreamController<Error> errorStreamController = StreamController();
  Stream<Error> get errorStream => errorStreamController.stream;
  Sink<Error> get errorSink => errorStreamController.sink;

  String getAppKey() => _client.secrets.appkey;
  String getAppSecret() => _client.secrets.secret;

  final SearchApi search;
  final LinksApi links;
  final EntriesApi entries;
  final UsersApi users;
  final MyWykopApi mywykop;
  final TagsApi tags;
  final ProfilesApi profiles;
  final NotificationsApi notifications;
  final SuggestApi suggest;
  final EmbedApi embed;
  final PmApi pm;

  AuthCredentials get credentials => _client.credentials;

  void setUserToken(AuthCredentials credentials) {
    _client.credentials = credentials;
  }

  Future<void> ensureSynced() async {
    await this._client.syncCredsFromStorage();
  }

  Future<void> logoutUser() async {
    await this._client.logoutUser();
  }

  WykopApiClient(this._client, this.search, this.links, this.entries, this.users, this.mywykop, this.tags,
      this.profiles, this.notifications, this.suggest, this.embed, this.pm) {
    _client.initialize();

  }
}

class ApiInitializer {
  ApiInitializer initialize(){
    setupMappersDeps();
    setupApiDeps();
    return this;
  }

  WykopApiClient getApiClient() {
    return WykopApiClient(
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
      appInjector.getDependency(),
    );
  }
}



var api = ApiInitializer().initialize().getApiClient();
