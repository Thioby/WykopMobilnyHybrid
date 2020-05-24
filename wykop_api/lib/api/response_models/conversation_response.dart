import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wykop_api/api/response_models/author_response.dart';
part 'conversation_response.g.dart';

abstract class ConversationResponse implements Built<ConversationResponse, ConversationResponseBuilder> {
  factory ConversationResponse([updates(ConversationResponseBuilder b)]) = _$ConversationResponse;

  @BuiltValueField(wireName: "last_update")
  String get lastUpdate;

  @nullable
  String get status;

  @nullable
  AuthorResponse get receiver;

  ConversationResponse._();

  static Serializer<ConversationResponse> get serializer => _$conversationResponseSerializer;
}
