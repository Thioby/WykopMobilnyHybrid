import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/EntryLinkDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/api/client.dart';

class SearchApi extends ApiResource {
  final EntryResponseToDtoMapper _entryResponseToDtoMapper;
  final LinkResponseToLinkDtoMapper _linkDtoMapper;
  final EntryLinkResponseToEntryLinkDtoMapper _entryLinkDtoMapper;

  SearchApi(ApiClient client, this._entryResponseToDtoMapper, this._linkDtoMapper, this._entryLinkDtoMapper)
      : super(client);

  Future<List<EntryDto>> searchEntries(int page, String q) async {
    var items = await client.request('search', 'entries', named: {'page': page.toString()}, post: {'q': q});
    return deserializeEntries(items);
  }

  Future<List<LinkDto>> searchLinks(int page, String q) async {
    var items = await client.request('search', 'links', named: {'page': page.toString()}, post: {'q': q});
    return deserializeLinks(items);
  }

  Future<List<EntryLinkDto>> searchIndex(int page, String q) async {
    var items = await client.request('search', 'index', named: {'page': page.toString()}, post: {'q': q});
    return deserializeEntryLinks(items);
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
}
