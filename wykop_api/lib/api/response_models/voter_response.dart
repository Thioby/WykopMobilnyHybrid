import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:wykop_api/api/response_models/author_response.dart';

part 'voter_response.g.dart';

abstract class VoterResponse implements Built<VoterResponse, VoterResponseBuilder> {
  factory VoterResponse([updates(VoterResponseBuilder b)]) = _$VoterResponse;

  AuthorResponse get author;

  String get date;

  @BuiltValueField(wireName: "vote_type")
  String get voteType;

  VoterResponse._();

  static Serializer<VoterResponse> get serializer => _$voterResponseSerializer;
}
