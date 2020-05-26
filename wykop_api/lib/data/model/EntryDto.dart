import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryMediaDto.dart';

class EntryDto implements Equatable {
  final int id;
  final String body;
  final String date;
  final int voteCount;
  final int commentsCount;
  final bool isVoted;
  final bool isExpanded;
  final bool isFavorite;
  final List<EntryCommentDto> comments;
  final AuthorDto author;
  final EntryMediaDto media;
  final String violationUrl;
  final String app;

  EntryDto(
      {this.id,
      this.body,
      this.voteCount,
      this.commentsCount,
      this.isVoted,
      this.isExpanded,
      this.isFavorite,
      this.comments,
      this.author,
      this.media,
      this.violationUrl,
      this.app,
      this.date});

  @override
  // TODO: implement props
  List<Object> get props => [id];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}

class EntryResponseToDtoMapper implements DataMapper<EntryResponse, EntryDto> {
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;
  final EntryMediaResponseToEntryMediaDtoMapper _mediaDtoMapper;
  final EntryCommentResponseToEntryCommentDtoMapper _commentDtoMapper;

  EntryResponseToDtoMapper(this._authorDtoMapper, this._mediaDtoMapper, this._commentDtoMapper);

  @override
  EntryDto apply(EntryResponse response) {
    List<EntryCommentDto> mappedComments = response.comments?.map<EntryCommentDto>(_commentDtoMapper.apply) ?? [];

    return EntryDto(
      id: response.id,
      date: response.date,
      body: response.body,
      voteCount: response.voteCount,
      isExpanded: true,
      commentsCount: response.commentsCount ?? 0,
      comments: mappedComments,
      isVoted: response.userVote != null && response.userVote > 0,
      isFavorite: response.favorite,
      author: _authorDtoMapper.apply(response.author),
      media: _mediaDtoMapper.apply(response.embed),
      violationUrl: response.violationUrl,
      app: response.app,
    );
  }
}
