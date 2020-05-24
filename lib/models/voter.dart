import 'package:built_value/built_value.dart';
import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/response_models/voter_response.dart';

part 'voter.g.dart';

abstract class Voter implements Built<Voter, VoterBuilder> {
  Author get author;

  String get date;

  String get voteType;

  factory Voter.fromResponse({VoterResponse response}) {
    return _$Voter._(
      author: Author.fromResponse(response: response.author),
      date: response.date,
      voteType: response.voteType,
    );
  }

  Voter._();
}
