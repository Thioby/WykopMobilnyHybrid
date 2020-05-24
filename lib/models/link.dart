import 'package:built_value/built_value.dart';
import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';

part 'link.g.dart';

abstract class Link implements Built<Link, LinkBuilder> {
  int get id;
  String get date;

  String get title;

  String get description;

  String get tags;

  String get sourceUrl;

  int get voteCount;

  int get buryCount;

  bool get isFavorite;

  int get commentsCount;

  int get relatedCount;

  LinkVoteState get voteState;

  Author get author;

  @nullable
  String get preview;

  bool get isHot;
  bool get isExpanded;

  bool get canVote;

  @nullable
  String get violationUrl;
  
  @nullable
  String get app;

  factory Link.mapFromResponse(LinkResponse response) {
    var voteState = LinkVoteState.NONE;
    if (response.userVote == "dig") {
      voteState = LinkVoteState.DIGGED;
    }

    if (response.userVote == "bury") {
      voteState = LinkVoteState.BURIED;
    }

    return _$Link._(
      id: response.id,
      date: response.date,
      title: response.title,
      isExpanded: true,
      voteCount: response.voteCount,
      commentsCount: response.commentsCount,
      author: Author.fromResponse(response: response.author),
      isHot: response.isHot,
      buryCount: response.buryCount,
      voteState: voteState,
      preview: // Makes link previews load in full resolution
          response.preview != null
              ? response.preview.split(',')[0] +
                  '.' +
                  response.preview.split(',')[1].split('.')[1]
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

  Link._();
}
