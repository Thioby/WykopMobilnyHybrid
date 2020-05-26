import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/EntryMediaDto.dart';

class LinkCommentDto implements Equatable {
  final int id;

  final String date;

  final String body;

  final bool isExpanded;

  final int voteCount;

  final int voteCountPlus;

  final int userVote;

  final String linkId;

  final int parentId;

  final List<LinkCommentDto> children;

  final int voteState;

  final bool isBlocked;

  final AuthorDto author;

  final EntryMediaDto embed;

  final String violationUrl;

  LinkCommentDto(
      {this.id,
      this.date,
      this.body,
      this.isExpanded,
      this.voteCount,
      this.voteCountPlus,
      this.userVote,
      this.linkId,
      this.parentId,
      this.children,
      this.voteState,
      this.isBlocked,
      this.author,
      this.embed,
      this.violationUrl});

  @override
  List<Object> get props => [id, userVote, voteCount];

  @override
  bool get stringify => true;
}

class LinkCommentResponseToLinkCommentDtoMapper implements DataMapper<LinkCommentResponse, LinkCommentDto> {
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;
  final EntryMediaResponseToEntryMediaDtoMapper _entryMediaDtoMapper;

  LinkCommentResponseToLinkCommentDtoMapper(this._authorDtoMapper, this._entryMediaDtoMapper);

  @override
  LinkCommentDto apply(LinkCommentResponse response) {
    return LinkCommentDto(
        id: response.id,
        date: response.date,
        body: response.body,
        isExpanded: true,
        isBlocked: response.isBlocked,
        userVote: response.userVote,
        voteCountPlus: response.voteCountPlus,
        parentId: response.parentId,
        linkId: response.link,
        voteCount: response.voteCount,
        children: [],
        author: _authorDtoMapper.apply(response.author),
        voteState: response.userVote,
        embed: _entryMediaDtoMapper.apply(response.embed),
        violationUrl: response.violationUrl);
  }
}
