import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/api/response_models/voter_response.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/InputData.dart';
import 'package:wykop_api/data/model/VoterDto.dart';
import 'package:wykop_api/api/client.dart';

class EntriesApi extends ApiResource {
  final EntryResponseToDtoMapper _entryResponseToDtoMapper;
  final EntryCommentResponseToEntryCommentDtoMapper _commentDtoMapper;
  final VoterResponseToVoterDtoMapper _voterResponseToVoterDtoMapper;

  EntriesApi(ApiClient client, this._entryResponseToDtoMapper, this._commentDtoMapper, this._voterResponseToVoterDtoMapper) : super(client);


  Future<List<EntryDto>> getFavorite(int page) async {
    var items = await client.request('entries', 'observed', named: {'page': page.toString()});
    return client.deserializeList(EntryResponse.serializer, items).map(_entryResponseToDtoMapper.apply).toList();
  }

  Future<List<EntryDto>> getHot(int page, String period) async {
    var items = await client.request('entries', 'hot', named: {'period': period, 'page': page.toString()});
    return client.deserializeList(EntryResponse.serializer, items).map(_entryResponseToDtoMapper.apply).toList();
  }

  Future<List<EntryDto>> getNewest(int page) async {
    var items = await client.request('entries', 'stream', named: {'page': page.toString()});
    return client.deserializeList(EntryResponse.serializer, items).map(_entryResponseToDtoMapper.apply).toList();
  }

  Future<List<EntryDto>> getActive(int page) async {
    var items = await client.request('entries', 'active', named: {'page': page.toString()});
    return client.deserializeList(EntryResponse.serializer, items).map(_entryResponseToDtoMapper.apply).toList();
  }

  Future<EntryDto> getEntry(int id) async {
    var items = await client.request('entries', 'entry', api: [id.toString()]);
    return _entryResponseToDtoMapper.apply(
      client.deserializeElement(EntryResponse.serializer, items),
    );
  }

  Future<EntryCommentDto> addEntryComment(int entryId, InputData data) async {
    var comment = await client.request('entries', 'commentadd',
        api: [entryId.toString()], post: {'body': data.body}, image: data.file);
    print(comment);
    return deserializeEntryComment(comment);
  }

  Future<List<VoterDto>> getEntryUpVoters(int entryId) async {
    var items = await client.request('entries', 'upvoters', api: [entryId.toString()]);
    print(items);
    var voters = client.deserializeList(VoterResponse.serializer, items);
    return voters.map(_voterResponseToVoterDtoMapper.apply).toList();
  }

  Future<List<VoterDto>> getEntryCommentUpVoters(int entryId) async {
    var items = await client.request('entries', 'commentupvoters', api: [entryId.toString()]);
    print(items);
    var voters = client.deserializeList(VoterResponse.serializer, items);
    return voters.map(_voterResponseToVoterDtoMapper.apply).toList();
  }

  Future<EntryDto> addEntry(InputData data) async {
    var entry = await client.request('entries', 'add', post: {'body': data.body}, image: data.file);
    return deserializeEntry(entry);
  }

  Future<int> voteUp(int id) async {
    var voteCount = await client.request('entries', 'voteup', api: [id.toString()]);

    return int.parse(voteCount["vote_count"]);
  }

  Future<bool> markFavorite(int id) async {
    var res = await client.request('entries', 'favorite', api: [id.toString()]);
    return res["user_favorite"] as bool;
  }

  Future<int> voteDown(int id) async {
    var voteCount = await client.request('entries', 'voteremove', api: [id.toString()]);
    print(voteCount);
    return int.parse(voteCount["vote_count"]);
  }

  Future<int> voteComemntUp(int id) async {
    var voteCount = await client.request('entries', 'commentvoteup', api: [id.toString()]);

    return int.parse(voteCount["vote_count"]);
  }

  Future<void> deleteEntry(int id) async {
    await client.request('entries', 'delete', api: [id.toString()]);
  }

  Future<EntryDto> editEntry(int id, InputData data) async {
    var entry =
        await client.request('entries', 'edit', api: [id.toString()], post: {'body': data.body}, image: data.file);
    return _entryResponseToDtoMapper.apply(client.deserializeElement(EntryResponse.serializer, entry));
  }

  Future<EntryCommentDto> editEntryComment(int id, InputData data) async {
    var entry = await client.request('entries', 'CommentEdit',
        api: [id.toString()], post: {'body': data.body}, image: data.file);
    return _commentDtoMapper.apply(
      client.deserializeElement(EntryCommentResponse.serializer, entry),
    );
  }

  Future<void> deleteComment(int id) async {
    await client.request('entries', 'commentdelete', api: [id.toString()]);
  }

  Future<int> voteCommentDown(int id) async {
    var voteCount = await client.request('entries', 'commentvoteremove', api: [id.toString()]);
    print(voteCount);
    return int.parse(voteCount["vote_count"]);
  }

  EntryDto deserializeEntry(dynamic item) {
    return _entryResponseToDtoMapper.apply(client.deserializeElement(EntryResponse.serializer, item));
  }

  EntryCommentDto deserializeEntryComment(dynamic item) {
    return _commentDtoMapper.apply(client.deserializeElement(EntryCommentResponse.serializer, item));
  }

}
