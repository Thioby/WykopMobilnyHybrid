import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/api/response_models/voter_response.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/EntryLinkDto.dart';
import 'package:wykop_api/data/model/LinkCommentDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/data/model/NotificationDto.dart';
import 'package:wykop_api/data/model/ProfileRelatedDto.dart';
import 'package:wykop_api/data/model/RelatedDto.dart';
import 'package:wykop_api/data/model/VouterDto.dart';

abstract class ApiResource {
  ApiClient _client;
  ApiClient get client => _client;
  final EntryResponseToDtoMapper _entryResponseToDtoMapper;
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;
  final LinkResponseToLinkDtoMapper _linkDtoMapper;
  final EntryLinkResponseToEntryLinkDtoMapper _entryLinkDtoMapper;
  final EntryCommentResponseToEntryCommentDtoMapper _commentDtoMapper;
  final LinkCommentResponseToLinkCommentDtoMapper _linkCommentDtoMapper;
  final VoterResponseToVoterDtoMapper _voterResponseToVoterDtoMapper;
  final RelatedResponseToRelatedDtoMapper _relatedDtoMapper;
  final ProfileRelatedResponseToRelatedDtoMapper _profileRelatedResponseToRelatedDtoMapper;
  final NotificationResponseToNotificationDtoMapper _notificationDtoMapper;

  ApiResource(
    ApiClient client,
    this._entryResponseToDtoMapper,
    this._authorDtoMapper,
    this._linkDtoMapper,
    this._entryLinkDtoMapper,
    this._commentDtoMapper,
    this._linkCommentDtoMapper,
    this._voterResponseToVoterDtoMapper,
    this._relatedDtoMapper,
    this._profileRelatedResponseToRelatedDtoMapper,
    this._notificationDtoMapper,
  ) {
    this._client = client;
  }

  List<EntryDto> deserializeEntries(dynamic items) {
    return _client.deserializeList(EntryResponse.serializer, items).map(_entryResponseToDtoMapper.apply).toList();
  }

  List<LinkDto> deserializeLinks(dynamic items) {
    return _client.deserializeList(LinkResponse.serializer, items).map(_linkDtoMapper.apply).toList();
  }

  LinkCommentDto deserializeLinkComment(dynamic item) {
    return _linkCommentDtoMapper.apply(_client.deserializeElement(LinkCommentResponse.serializer, item));
  }

  EntryCommentDto deserializeEntryComment(dynamic item) {
    return _commentDtoMapper.apply(_client.deserializeElement(EntryCommentResponse.serializer, item));
  }

  EntryDto deserializeEntry(dynamic item) {
    return _entryResponseToDtoMapper.apply(_client.deserializeElement(EntryResponse.serializer, item));
  }

  LinkDto deserializeLink(dynamic item) {
    return _linkDtoMapper.apply(_client.deserializeElement(LinkResponse.serializer, item));
  }

  AuthorDto deserializeAuthor(dynamic item) {
    AuthorResponse authorResponse = _client.deserializeElement(AuthorResponse.serializer, item);
    return _authorDtoMapper.apply(authorResponse);
  }

  ProfileResponse deserializeProfile(dynamic item) {
    return _client.deserializeElement(ProfileResponse.serializer, item);
  }

  List<EntryLinkDto> deserializeEntryLinks(dynamic items) {
    return _client.deserializeList(EntryLinkResponse.serializer, items).map(_entryLinkDtoMapper.apply).toList();
  }

  List<VoterDto> deserializeUpvoters(dynamic items) {
    return _client.deserializeList(VoterResponse.serializer, items).map(_voterResponseToVoterDtoMapper.apply).toList();
  }

  List<NotificationDto> deserializeNotifications(dynamic items) {
    return _client.deserializeList(NotificationResponse.serializer, items).map(_notificationDtoMapper.apply).toList();
  }

  List<LinkCommentDto> deserializeLinkComments(dynamic items) {
    return _client.deserializeList(LinkCommentResponse.serializer, items).map(_linkCommentDtoMapper.apply).toList();
  }

  List<EntryCommentDto> deserializeEntryComments(dynamic items) {
    return _client.deserializeList(EntryCommentResponse.serializer, items).map(_commentDtoMapper.apply).toList();
  }

  List<RelatedDto> deserializeRelatedLinks(dynamic items) {
    print(items);

    return _client.deserializeList(RelatedResponse.serializer, items).map(_relatedDtoMapper.apply).toList();
  }

  List<ProfileRelatedDto> deserializeProfileRelated(dynamic items) {
    return _client
        .deserializeList(ProfileRelatedResponse.serializer, items)
        .map(_profileRelatedResponseToRelatedDtoMapper.apply)
        .toList();
  }
}
