import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/EntryMediaDto.dart';

class EntryCommentDto implements Equatable {
  final int id;
  final String date;
  final String body;
  final int voteCount;
  final bool isVoted;
  final bool isExpanded;
  final AuthorDto author;
  final EntryMediaDto embed;
  final String violationUrl;
  final String app;

  EntryCommentDto(
      {this.id,
      this.date,
      this.body,
      this.voteCount,
      this.isVoted,
      this.isExpanded,
      this.author,
      this.embed,
      this.violationUrl,
      this.app});

  @override
  List<Object> get props => [id];

  @override
  bool get stringify => false;
}

class EntryCommentResponseToEntryCommentDtoMapper implements DataMapper<EntryCommentResponse, EntryCommentDto> {
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;
  final EntryMediaResponseToEntryMediaDtoMapper _mediaDtoMapper;

  EntryCommentResponseToEntryCommentDtoMapper(this._authorDtoMapper, this._mediaDtoMapper);

  @override
  EntryCommentDto apply(EntryCommentResponse response) {
    return EntryCommentDto(
      id: response.id,
      isExpanded: true,
      date: response.date,
      body: response.body,
      voteCount: response.voteCount,
      author: _authorDtoMapper.apply(response.author),
      isVoted: response.userVote != null && response.userVote > 0,
      embed: _mediaDtoMapper.apply(response.embed),
      violationUrl: response.violationUrl,
      app: response.app,
    );
  }
}
