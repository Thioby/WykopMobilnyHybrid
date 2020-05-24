import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';

class SearchApi extends ApiResource {
  SearchApi(ApiClient client) : super(client);

  Future<List<Entry>> searchEntries(int page, String q) async {
    var items = await client.request('search', 'entries', named: {'page': page.toString()}, post: {'q': q});
    return deserializeEntries(items);
  }

  Future<List<Link>> searchLinks(int page, String q) async {
    var items = await client.request('search', 'links', named: {'page': page.toString()}, post: {'q': q});
    return deserializeLinks(items);
  }

  Future<List<EntryLink>> searchIndex(int page, String q) async {
    var items = await client.request('search', 'index', named: {'page': page.toString()}, post: {'q': q});
    return deserializeEntryLinks(items);
  }
}
