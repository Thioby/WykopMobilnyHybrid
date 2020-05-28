import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/AuthorSuggestionDto.dart';
import 'package:wykop_api/data/model/TagSuggestionDto.dart';

class SuggestApi extends ApiResource {
  final TagSuggestionResponseToTagSuggestionDtoMapper _tagSuggestionDtoMapper;
  final AuthorSuggestionResponseToAuthorSuggestionDtoMapper _authorSuggestionDtoMapper;

  SuggestApi(ApiClient client, this._tagSuggestionDtoMapper, this._authorSuggestionDtoMapper) : super(client);

  Future<List<AuthorSuggestionDto>> suggestUsers(String q) async {
    var items = await client.request('suggest', 'users', api: [q]);
    return client
        .deserializeList(AuthorSuggestionResponse.serializer, items)
        .map(_authorSuggestionDtoMapper.apply)
        .toList();
  }

  Future<List<TagSuggestionDto>> suggestTags(String q) async {
    var items = await client.request('suggest', 'tags', api: [q]);
    return client.deserializeList(TagSuggestionResponse.serializer, items).map(_tagSuggestionDtoMapper.apply).toList();
  }
}
