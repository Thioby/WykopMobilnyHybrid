import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';

class TagMeta {
  final String description;
  final int entriesCount;
  final int linksCount;

  final String backgroundUrl;
  final Author owner;
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
  TagsApi(ApiClient client) : super(client);

  Future<List<EntryLink>> getIndex(String tag, int page) async {
    var items = await client.request('tags', 'index', api: [tag], named: {'page': page.toString()});

    return deserializeEntryLinks(items);
  }

  Future<List<Link>> getLinks(String tag, int page) async {
    var items = await client.request('tags', 'links', api: [tag], named: {'page': page.toString()});

    return deserializeLinks(items);
  }

  Future<List<Entry>> getEntries(String tag, int page) async {
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

    Author owner;
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
}
