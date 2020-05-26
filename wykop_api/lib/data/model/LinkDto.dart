import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';

class LinkDto implements Equatable {
  final int id;
  final String date;

  final String title;

  final String description;

  final String tags;

  final String sourceUrl;

  final int voteCount;

  final int buryCount;

  final bool isFavorite;

  final int commentsCount;

  final int relatedCount;

  final LinkVoteState voteState;

  final AuthorDto author;

  final String preview;

  final bool isHot;
  final bool isExpanded;

  final bool canVote;

  final String violationUrl;

  final String app;

  LinkDto(
      {this.id,
      this.date,
      this.title,
      this.description,
      this.tags,
      this.sourceUrl,
      this.voteCount,
      this.buryCount,
      this.isFavorite,
      this.commentsCount,
      this.relatedCount,
      this.voteState,
      this.author,
      this.preview,
      this.isHot,
      this.isExpanded,
      this.canVote,
      this.violationUrl,
      this.app});

  @override
  List<Object> get props => [id];

  @override
  bool get stringify => true;
}

class LinkResponseToLinkDtoMapper implements DataMapper<LinkResponse, LinkDto> {
  final AuthorResponseToAuthorDtoMapper _authorDtoMapper;

  LinkResponseToLinkDtoMapper(this._authorDtoMapper);

  @override
  LinkDto apply(LinkResponse response) {
    var voteState = LinkVoteState.NONE;
    if (response.userVote == "dig") {
      voteState = LinkVoteState.DIGGED;
    }

    if (response.userVote == "bury") {
      voteState = LinkVoteState.BURIED;
    }

    return LinkDto(
      id: response.id,
      date: response.date,
      title: response.title,
      isExpanded: true,
      voteCount: response.voteCount,
      commentsCount: response.commentsCount,
      author: _authorDtoMapper.apply(response.author),
      isHot: response.isHot,
      buryCount: response.buryCount,
      voteState: voteState,
      preview: // Makes link previews load in full resolution
          response.preview != null
              ? response.preview.split(',')[0] + '.' + response.preview.split(',')[1].split('.')[1]
              : null,
      isFavorite: response.favorite ?? false,
      sourceUrl: response.sourceUrl,
      canVote: response.canVote,
      description: response.description ?? '',
      relatedCount: response.relatedCount,
      tags: response.tags,
      violationUrl: response.violationUrl,
      app: response.app,
    );
  }
}
