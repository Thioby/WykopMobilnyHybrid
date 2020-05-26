import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';

class RelatedDto implements Equatable {
  final int id;
  final String url;

  final String title;

  final int voteCount;

  final bool isVoted;
  final AuthorDto author;

  RelatedDto({
    this.id,
    this.url,
    this.title,
    this.voteCount,
    this.isVoted,
    this.author,
  });

  @override
  List<Object> get props => [id];

  @override
  bool get stringify => true;
}

class RelatedResponseToRelatedDtoMapper implements DataMapper<RelatedResponse, RelatedDto> {
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;

  RelatedResponseToRelatedDtoMapper(this._authorDtoMapper);

  @override
  RelatedDto apply(RelatedResponse response) {
    return RelatedDto(
      id: response.id,
      url: response.url,
      title: response.title,
      voteCount: response.voteCount,
      isVoted: false,
      author: _authorDtoMapper.apply(response.author),
    );
  }
}
