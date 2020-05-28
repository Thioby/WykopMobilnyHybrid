import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/EntryLinkDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';

class TagMeta {
  final String description;
  final int entriesCount;
  final int linksCount;

  final String backgroundUrl;
  final AuthorDto owner;
  final bool isOwn;
  final bool isObserved;
  final bool isBlocked;

  TagMeta(
      {this.description,
      this.entriesCount,
      this.linksCount,
      this.backgroundUrl,
      this.owner,
      this.isOwn,
      this.isObserved,
      this.isBlocked});
}

class TagsApi extends ApiResource {
  final LinkResponseToLinkDtoMapper _linkDtoMapper;
  final EntryResponseToDtoMapper _entryResponseToDtoMapper;
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;
  final EntryLinkResponseToEntryLinkDtoMapper _entryLinkDtoMapper;

  TagsApi(ApiClient client, this._linkDtoMapper, this._entryResponseToDtoMapper, this._authorDtoMapper,
      this._entryLinkDtoMapper)
      : super(client);

  Future<List<EntryLinkDto>> getIndex(String tag, int page) async {
    var items = await client.request('tags', 'index', api: [tag], named: {'page': page.toString()});

    return deserializeEntryLinks(items);
  }

  Future<List<LinkDto>> getLinks(String tag, int page) async {
    var items = await client.request('tags', 'links', api: [tag], named: {'page': page.toString()});

    return deserializeLinks(items);
  }

  Future<List<EntryDto>> getEntries(String tag, int page) async {
    var items = await client.request('tags', 'entries', api: [tag], named: {'page': page.toString()});

    return deserializeEntries(items);
  }

  Future<List<String>> getObservedTags() async {
    var items = await client.request('tags', 'observed');
    return List<String>.from(items.map((e) => e["tag"]).toList());
  }

  Future<TagMeta> getMeta(String tag) async {
    var data = await client.request('tags', 'index', api: [tag], named: {'page': '0'}, returnFullResponse: true);

    var meta = data["meta"];

    AuthorDto owner;
    if (meta["owner"] != null) {
      owner = deserializeAuthor(meta["owner"]);
    }

    return TagMeta(
      description: meta["description"],
      backgroundUrl: meta["background"],
      isOwn: meta["is_own"],
      isBlocked: meta["is_blocked"],
      isObserved: meta["is_observed"],
      entriesCount: meta["counters"]["entries"],
      linksCount: meta["counters"]["links"],
      owner: owner,
    );
  }

  List<LinkDto> deserializeLinks(dynamic items) {
    return client.deserializeList(LinkResponse.serializer, items).map(_linkDtoMapper.apply).toList();
  }

  List<EntryDto> deserializeEntries(dynamic items) {
    return client.deserializeList(EntryResponse.serializer, items).map(_entryResponseToDtoMapper.apply).toList();
  }

  AuthorDto deserializeAuthor(dynamic item) {
    AuthorResponse authorResponse = client.deserializeElement(AuthorResponse.serializer, item);
    return _authorDtoMapper.apply(authorResponse);
  }

  List<EntryLinkDto> deserializeEntryLinks(dynamic items) {
    return client.deserializeList(EntryLinkResponse.serializer, items).map(_entryLinkDtoMapper.apply).toList();
  }
}
