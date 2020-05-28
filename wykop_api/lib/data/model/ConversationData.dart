import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/PmMessageDto.dart';

class ConversationDataDto {
  List<PmMessageDto> messages;
  AuthorDto receiver;
  String lastUpdate;
  ConversationDataDto({this.receiver, this.messages, this.lastUpdate});
}
