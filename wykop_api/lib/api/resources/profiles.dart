import 'dart:async';
import 'dart:core';

import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/EntryLinkDto.dart';
import 'package:wykop_api/data/model/LinkCommentDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/data/model/ProfileRelatedDto.dart';
import 'package:wykop_api/api/client.dart';

class ProfilesApi extends ApiResource {
  final EntryResponseToDtoMapper _entryResponseToDtoMapper;
  final LinkResponseToLinkDtoMapper _linkDtoMapper;
  final EntryLinkResponseToEntryLinkDtoMapper _entryLinkDtoMapper;
  final ProfileRelatedResponseToRelatedDtoMapper _profileRelatedResponseToRelatedDtoMapper;
  final LinkCommentResponseToLinkCommentDtoMapper _linkCommentDtoMapper;
  final EntryCommentResponseToEntryCommentDtoMapper _commentDtoMapper;

  ProfilesApi(
    ApiClient client,
    this._entryResponseToDtoMapper,
    this._linkDtoMapper,
    this._entryLinkDtoMapper,
    this._profileRelatedResponseToRelatedDtoMapper,
    this._linkCommentDtoMapper,
    this._commentDtoMapper,
  ) : super(client);

  Future<List<EntryLinkDto>> getActions(String username) async {
    var items = await client.request('profiles', 'actions', api: [username], named: {'page': '1'});
    return deserializeEntryLinks(items);
  }

  Future<List<LinkDto>> getAddedLinks(int page, String username) async {
    var items = await client.request('profiles', 'added', api: [username], named: {'page': page.toString()});
    return deserializeLinks(items);
  }

  Future<List<LinkDto>> getCommentedLinks(int page, String username) async {
    var items = await client.request('profiles', 'commented', api: [username], named: {'page': page.toString()});
    return deserializeLinks(items);
  }

  Future<List<LinkDto>> getPublishedLinks(int page, String username) async {
    var items = await client.request('profiles', 'published', api: [username], named: {'page': page.toString()});
    return deserializeLinks(items);
  }

  Future<List<LinkCommentDto>> getLinkComments(int page, String username) async {
    var items = await client.request('profiles', 'comments', api: [username], named: {'page': page.toString()});
    return deserializeLinkComments(items);
  }

  Future<List<EntryDto>> getEntries(int page, String username) async {
    var items = await client.request('profiles', 'entries', api: [username], named: {'page': page.toString()});
    return deserializeEntries(items);
  }

  Future<List<EntryDto>> getCommentedEntries(int page, String username) async {
    var items = await client.request('profiles', 'commentedentries', api: [username], named: {'page': page.toString()});
    return deserializeEntries(items);
  }

  Future<List<EntryCommentDto>> getEntryComments(int page, String username) async {
    var items = await client.request('profiles', 'entriescomments', api: [username], named: {'page': page.toString()});
    return deserializeEntryComments(items);
  }

  Future<List<LinkCommentDto>> getFollowers(int page, String username) async {
    var items = await client.request('profiles', 'followers', api: [username], named: {'page': page.toString()});
    return deserializeLinkComments(items);
  }

  Future<List<LinkCommentDto>> getFollowed(int page, String username) async {
    var items = await client.request('profiles', 'followed', api: [username], named: {'page': page.toString()});
    return deserializeLinkComments(items);
  }

  Future<List<ProfileRelatedDto>> getProfileRelated(int page, String username) async {
    var items = await client.request('profiles', 'related', api: [username], named: {'page': page.toString()});
    return deserializeProfileRelated(items);
  }

  Future<ProfileResponse> getProfile(String username) async {
    var items = await client.request('profiles', 'index', api: [username]);
    print(items);
    return deserializeProfile(items);
  }

  Future<List<LinkDto>> getDigged(int page, String username) async {
    var items = await client.request('profiles', 'digged', api: [username], named: {'page': page.toString()});
    return deserializeLinks(items);
  }

  Future<List<LinkDto>> getBuried(int page, String username) async {
    var items = await client.request('profiles', 'buried', api: [username], named: {'page': page.toString()});
    return deserializeLinks(items);
  }

  Future<bool> observe(String username) async {
    var items = await client.request('profiles', 'observe', api: [username]);
    return items["is_observed"];
  }

  Future<bool> unobserve(String username) async {
    var items = await client.request('profiles', 'unobserve', api: [username]);
    return items["is_observed"];
  }

  Future<bool> block(String username) async {
    var items = await client.request('profiles', 'block', api: [username]);
    return items["is_blocked"];
  }

  Future<bool> unblock(String username) async {
    var items = await client.request('profiles', 'unblock', api: [username]);
    return items["is_blocked"];
  }

  List<EntryDto> deserializeEntries(dynamic items) {
    return client.deserializeList(EntryResponse.serializer, items).map(_entryResponseToDtoMapper.apply).toList();
  }

  List<LinkDto> deserializeLinks(dynamic items) {
    return client.deserializeList(LinkResponse.serializer, items).map(_linkDtoMapper.apply).toList();
  }

  List<EntryLinkDto> deserializeEntryLinks(dynamic items) {
    return client.deserializeList(EntryLinkResponse.serializer, items).map(_entryLinkDtoMapper.apply).toList();
  }

  List<ProfileRelatedDto> deserializeProfileRelated(dynamic items) {
    return client
        .deserializeList(ProfileRelatedResponse.serializer, items)
        .map(_profileRelatedResponseToRelatedDtoMapper.apply)
        .toList();
  }

  LinkCommentDto deserializeLinkComment(dynamic item) {
    return _linkCommentDtoMapper.apply(client.deserializeElement(LinkCommentResponse.serializer, item));
  }

  List<LinkCommentDto> deserializeLinkComments(dynamic items) {
    return client.deserializeList(LinkCommentResponse.serializer, items).map(_linkCommentDtoMapper.apply).toList();
  }

  ProfileResponse deserializeProfile(dynamic item) {
    return client.deserializeElement(ProfileResponse.serializer, item);
  }

  List<EntryCommentDto> deserializeEntryComments(dynamic items) {
    return client.deserializeList(EntryCommentResponse.serializer, items).map(_commentDtoMapper.apply).toList();
  }
}
