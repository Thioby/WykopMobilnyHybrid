import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/response_models/voter_response.dart';
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';

class VoterDto implements Equatable {
  final AuthorDto author;

  final String date;

  final String voteType;

  VoterDto({
    this.author,
    this.date,
    this.voteType,
  });

  @override
  List<Object> get props => [author];

  @override
  bool get stringify => true;
}

class VoterResponseToVoterDtoMapper implements DataMapper<VoterResponse, VoterDto> {
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;

  VoterResponseToVoterDtoMapper(this._authorDtoMapper);

  @override
  VoterDto apply(VoterResponse response) {
    return VoterDto(
      author: _authorDtoMapper.apply(response.author),
      date: response.date,
      voteType: response.voteType,
    );
  }
}
