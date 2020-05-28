import 'dart:async' show Future;
import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
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
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/AuthorSuggestionDto.dart';
import 'package:wykop_api/data/model/ConversationDto.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/EntryLinkDto.dart';
import 'package:wykop_api/data/model/EntryMediaDto.dart';
import 'package:wykop_api/data/model/LinkCommentDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/data/model/NotificationDto.dart';
import 'package:wykop_api/data/model/PmMessageDto.dart';
import 'package:wykop_api/data/model/ProfileRelatedDto.dart';
import 'package:wykop_api/data/model/RelatedDto.dart';
import 'package:wykop_api/data/model/TagSuggestionDto.dart';
import 'package:wykop_api/data/model/VoterDto.dart';

import 'client.dart';

export 'client.dart';
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

String _getIdentity<T>() => "${T.hashCode.toString()}";

//todo someday there will be DI :)
typedef T DiBuilder<T>();

Map<String, DiBuilder<Object>> prepareDiMap() {
  Map<String, DiBuilder<DataMapper>> mappers = {};

  var authorMapper = AuthorResponseToAuthorDtoMapper();
  var mediaMapper = EntryMediaResponseToEntryMediaDtoMapper();
  var entryCommentMapper = EntryCommentResponseToEntryCommentDtoMapper(authorMapper, mediaMapper);
  var entryMapper = EntryResponseToDtoMapper(authorMapper, mediaMapper, entryCommentMapper);
  var linkMapper = LinkResponseToLinkDtoMapper(authorMapper);

  mappers[_getIdentity<AuthorResponseToAuthorDtoMapper>()] = () => authorMapper;
  mappers[_getIdentity<AuthorSuggestionResponseToAuthorSuggestionDtoMapper>()] =
      () => AuthorSuggestionResponseToAuthorSuggestionDtoMapper();
  mappers[_getIdentity<ConversationResponseToConversationDtoMapper>()] =
      () => ConversationResponseToConversationDtoMapper(authorMapper);
  mappers[_getIdentity<EntryCommentResponseToEntryCommentDtoMapper>()] = () => entryCommentMapper;
  mappers[_getIdentity<EntryResponseToDtoMapper>()] = () => entryMapper;
  mappers[_getIdentity<EntryLinkResponseToEntryLinkDtoMapper>()] =
      () => EntryLinkResponseToEntryLinkDtoMapper(linkMapper, entryMapper);
  mappers[_getIdentity<EntryMediaResponseToEntryMediaDtoMapper>()] = () => mediaMapper;
  mappers[_getIdentity<LinkCommentResponseToLinkCommentDtoMapper>()] =
      () => LinkCommentResponseToLinkCommentDtoMapper(authorMapper, mediaMapper);
  mappers[_getIdentity<LinkResponseToLinkDtoMapper>()] = () => LinkResponseToLinkDtoMapper(authorMapper);
  mappers[_getIdentity<NotificationResponseToNotificationDtoMapper>()] =
      () => NotificationResponseToNotificationDtoMapper(authorMapper);
  mappers[_getIdentity<PmMessageResponseToPmMessageDtoMapper>()] =
      () => PmMessageResponseToPmMessageDtoMapper(mediaMapper);
  mappers[_getIdentity<ProfileRelatedResponseToRelatedDtoMapper>()] = () => ProfileRelatedResponseToRelatedDtoMapper();
  mappers[_getIdentity<RelatedResponseToRelatedDtoMapper>()] = () => RelatedResponseToRelatedDtoMapper(authorMapper);
  mappers[_getIdentity<TagSuggestionResponseToTagSuggestionDtoMapper>()] =
      () => TagSuggestionResponseToTagSuggestionDtoMapper();
  mappers[_getIdentity<VoterResponseToVoterDtoMapper>()] = () => VoterResponseToVoterDtoMapper(authorMapper);

  return mappers;
}

class ApiMapperDi {
  final Map<String, DiBuilder<Object>> mappers = prepareDiMap();

  T getMapper<T>() {
    print("got: " + _getIdentity<T>());
    return mappers[_getIdentity<T>()]();
  }
}

class WykopApiClient {
  final ApiClient _client = ApiClient();
  final ApiMapperDi mapperInjector = ApiMapperDi();

  StreamController<Error> errorStreamController = StreamController();
  Stream<Error> get errorStream => errorStreamController.stream;
  Sink<Error> get errorSink => errorStreamController.sink;

  String getAppKey() => _client.secrets.appkey;
  String getAppSecret() => _client.secrets.secret;

  SearchApi search;
  LinksApi links;
  EntriesApi entries;
  UsersApi users;
  MyWykopApi mywykop;
  TagsApi tags;
  ProfilesApi profiles;
  NotificationsApi notifications;
  SuggestApi suggest;
  EmbedApi embed;
  PmApi pm;

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

  WykopApiClient() {
    _client.initialize();
    this.entries =
        EntriesApi(_client, mapperInjector.getMapper(), mapperInjector.getMapper(), mapperInjector.getMapper());
    this.users = UsersApi(_client);
    this.links = LinksApi(_client, mapperInjector.getMapper(), mapperInjector.getMapper(), mapperInjector.getMapper());
    this.tags = TagsApi(_client, mapperInjector.getMapper(), mapperInjector.getMapper(), mapperInjector.getMapper(),
        mapperInjector.getMapper());
    this.pm = PmApi(_client, mapperInjector.getMapper(), mapperInjector.getMapper(), mapperInjector.getMapper());
    this.suggest = SuggestApi(_client, mapperInjector.getMapper(), mapperInjector.getMapper());
    this.profiles = ProfilesApi(_client, mapperInjector.getMapper(), mapperInjector.getMapper(),
        mapperInjector.getMapper(), mapperInjector.getMapper(), mapperInjector.getMapper(), mapperInjector.getMapper());
    this.embed = EmbedApi(_client);
    this.search =
        SearchApi(_client, mapperInjector.getMapper(), mapperInjector.getMapper(), mapperInjector.getMapper());
    this.notifications = NotificationsApi(_client, mapperInjector.getMapper());
    this.mywykop = MyWykopApi(_client, mapperInjector.getMapper());
  }
}

var api = WykopApiClient();
