import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/ConversationData.dart';
import 'package:wykop_api/data/model/ConversationDto.dart';
import 'package:wykop_api/data/model/InputData.dart';
import 'package:wykop_api/data/model/PmMessageDto.dart';
import 'package:wykop_api/api/client.dart';

class PmApi extends ApiResource {
  final ConversationResponseToConversationDtoMapper _conversationDtoMapper;
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;
  final PmMessageResponseToPmMessageDtoMapper _messageResponseToPmMessageDtoMapper;
  PmApi(ApiClient client, this._conversationDtoMapper, this._authorDtoMapper, this._messageResponseToPmMessageDtoMapper)
      : super(client);

  Future<List<ConversationDto>> getConversations() async {
    var items = await client.request('pm', 'conversationslist');

    return client.deserializeList(ConversationResponse.serializer, items).map(_conversationDtoMapper.apply).toList();
  }

  Future<ConversationDataDto> getConversation(String receiver) async {
    var items = await client.request('pm', 'conversation', api: [receiver], returnFullResponse: true);

    var msgs = client
        .deserializeList(PmMessageResponse.serializer, items["data"])
        .map(_messageResponseToPmMessageDtoMapper.apply)
        .toList();
    var author = deserializeAuthor(items["receiver"]);

    print(items);
    return ConversationDataDto(
      messages: msgs,
      receiver: author,
      lastUpdate: items["last_update"],
    );
  }

  Future<List<PmMessageDto>> getMessages(String receiver) async {
    var items = await client.request('pm', 'conversation', api: [receiver]);

    return client
        .deserializeList(PmMessageResponse.serializer, items)
        .map(_messageResponseToPmMessageDtoMapper.apply)
        .toList();
  }

  Future<PmMessageDto> sendMessage(String receiver, InputData data) async {
    var pm = await client.request('pm', 'sendmessage', api: [receiver], post: {'body': data.body}, image: data.file);
    return _messageResponseToPmMessageDtoMapper.apply(client.deserializeElement(PmMessageResponse.serializer, pm));
  }

  AuthorDto deserializeAuthor(dynamic item) {
    AuthorResponse authorResponse = client.deserializeElement(AuthorResponse.serializer, item);
    return _authorDtoMapper.apply(authorResponse);
  }
}
