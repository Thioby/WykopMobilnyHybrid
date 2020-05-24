import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';

class SuggestApi extends ApiResource {
  SuggestApi(ApiClient client) : super(client);

  Future<List<AuthorSuggestion>> suggestUsers(String q) async {
    var items = await client.request('suggest', 'users', api: [q]);
    return client
        .deserializeList(AuthorSuggestionResponse.serializer, items)
        .map((a) => AuthorSuggestion.fromResponse(response: a))
        .toList();
  }

  Future<List<TagSuggestion>> suggestTags(String q) async {
    var items = await client.request('suggest', 'tags', api: [q]);
    return client
        .deserializeList(TagSuggestionResponse.serializer, items)
        .map((a) => TagSuggestion.fromResponse(response: a))
        .toList();
  }
}
