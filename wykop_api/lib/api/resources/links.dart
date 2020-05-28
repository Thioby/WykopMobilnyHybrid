import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/model/InputData.dart';
import 'package:wykop_api/data/model/LinkCommentDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/data/model/RelatedDto.dart';

// Used for vote up, vote down and vote cancel responses
class VoteStateResponse {
  final int votesPlus;
  final int votes;
  final int state;
  VoteStateResponse({this.votes, this.votesPlus, this.state});
}

class BuryReason {
  static const DUPLICATE = 1;
  static const SPAM = 2;
  static const FAKE_INFO = 3;
  static const NOT_APPROPRIATE_CONTENT = 4;
  static const INVALID = 5;
}

enum LinkVoteState {
  DIGGED,
  BURIED,
  NONE,
}

class DigResponse {
  final int digs;
  final int buries;
  final LinkVoteState state;
  DigResponse({this.digs, this.buries, this.state});
}

class UpcomingSort {
  static const SORTBY_COMMENTS = "comments";
  static const SORTBY_VOTES = "votes";
  static const SORTBY_DATE = "date";
  static const SORTBY_ACTIVE = "active";
}

class LinksApi extends ApiResource {
  final LinkCommentResponseToLinkCommentDtoMapper _linkCommentDtoMapper;
  final LinkResponseToLinkDtoMapper _linkDtoMapper;
  final RelatedResponseToRelatedDtoMapper _relatedDtoMapper;

  LinksApi(ApiClient client, this._linkCommentDtoMapper, this._linkDtoMapper, this._relatedDtoMapper) : super(client);

  Future<List<LinkDto>> _getLinks(String resource, String endpoint, int page) async {
    var items = await client.request(resource, endpoint, named: {'page': page.toString()});
    return client.deserializeList(LinkResponse.serializer, items).map(_linkDtoMapper.apply).toList();
  }

  Future<List<LinkDto>> getUpcoming(String sortBy, int page) async {
    var items = await client.request('links', 'upcoming', named: {'page': page.toString(), 'sort': sortBy});
    return client.deserializeList(LinkResponse.serializer, items).map(_linkDtoMapper.apply).toList();
  }

  Future<List<LinkDto>> getPromotedNew(int page) => _getLinks('links', 'promoted', page);

  Future<List<LinkDto>> getFavoriteNew(int page) => _getLinks('links', 'observed', page);

  Future<List<LinkDto>> getHitsPopular(int page) => _getLinks('hits', 'popular', page);

  Future<void> deleteComment(int id) async {
    await client.request('links', 'commentdelete', api: [id.toString()]);
  }

  Future<List<LinkDto>> getHitsDay(int page) => _getLinks('hits', 'day', page);

  Future<List<LinkDto>> getHitsWeek(int page) => _getLinks('hits', 'week', page);
  Future<List<LinkDto>> getHitsMonth(int page, int month, int year) async {
    var items = await client
        .request('hits', 'month', named: {'page': page.toString()}, api: [year.toString(), month.toString()]);
    return client.deserializeList(LinkResponse.serializer, items).map(_linkDtoMapper.apply).toList();
  }

  Future<List<LinkDto>> getHitsYear(int page, int year) async {
    var items = await client.request('hits', 'year', named: {'page': page.toString()}, api: [year.toString()]);
    return client.deserializeList(LinkResponse.serializer, items).map(_linkDtoMapper.apply).toList();
  }

  Future<LinkDto> getLink(int linkId) async {
    var items = await client.request('links', 'link', api: [linkId.toString()]);
    return deserializeLink(items);
  }

  Future<List<LinkCommentDto>> getLinkComments(int linkId) async {
    var items = await client.request('links', 'comments', api: [linkId.toString()]);
    return deserializeLinkComments(items);
  }

  Future<bool> markFavorite(int id) async {
    var res = await client.request('links', 'favorite', api: [id.toString()]);
    return res["user_favorite"] as bool;
  }

  Future<DigResponse> voteUp(String linkId) async {
    var voteCount = await client.request('links', 'voteup', api: [linkId]);
    print(voteCount);
    return DigResponse(digs: voteCount["digs"], buries: voteCount["buries"], state: LinkVoteState.DIGGED);
  }

  Future<DigResponse> voteRemove(String linkId) async {
    var voteCount = await client.request('links', 'voteremove', api: [linkId]);

    return DigResponse(digs: voteCount["digs"], buries: voteCount["buries"], state: LinkVoteState.NONE);
  }

  Future<DigResponse> voteDown(String linkId, int reason) async {
    var voteCount = await client.request('links', 'votedown', api: [linkId, reason.toString()]);

    return DigResponse(digs: voteCount["digs"], buries: voteCount["buries"], state: LinkVoteState.BURIED);
  }

  Future<VoteStateResponse> commentVoteUp(int linkCommentId, String linkId) async {
    var voteCount = await client.request('links', 'commentvoteup', api: [linkId, linkCommentId.toString()]);

    return VoteStateResponse(votes: voteCount["vote_count"], votesPlus: voteCount["vote_count_plus"], state: 1);
  }

  Future<VoteStateResponse> commentVoteRemove(int linkCommentId, String linkId) async {
    var voteCount = await client.request('links', 'commentvotecancel', api: [linkId, linkCommentId.toString()]);

    return VoteStateResponse(votes: voteCount["vote_count"], votesPlus: voteCount["vote_count_plus"], state: 0);
  }

  Future<VoteStateResponse> commentVoteDown(int linkCommentId, String linkId) async {
    var voteCount = await client.request('links', 'CommentVoteDown', api: [linkId, linkCommentId.toString()]);

    return VoteStateResponse(votes: voteCount["vote_count"], votesPlus: voteCount["vote_count_plus"], state: -1);
  }

  Future<List<RelatedDto>> getRelatedLinks(int linkId) async {
    var items = await client.request('links', 'related', api: [linkId.toString()]);
    return deserializeRelatedLinks(items);
  }

  Future<LinkCommentDto> addComment(int linkId, InputData data, {int commentId}) async {
    var linkComment;
    if (commentId != null) {
      linkComment = await client.request('links', 'CommentAdd',
          post: {'body': data.body}, image: data.file, api: [linkId.toString(), commentId.toString()]);
      print(linkComment);
    } else {
      linkComment = await client.request('links', 'CommentAdd',
          post: {'body': data.body}, image: data.file, api: [linkId.toString()]);
    }

    return deserializeLinkComment(linkComment);
  }

  Future<LinkCommentDto> editComment(int id, InputData data) async {
    var linkComment =
        await client.request('links', 'CommentEdit', post: {'body': data.body}, image: data.file, api: [id.toString()]);

    return deserializeLinkComment(linkComment);
  }

  List<RelatedDto> deserializeRelatedLinks(dynamic items) {
    print(items);

    return client.deserializeList(RelatedResponse.serializer, items).map(_relatedDtoMapper.apply).toList();
  }

  LinkCommentDto deserializeLinkComment(dynamic item) {
    return _linkCommentDtoMapper.apply(client.deserializeElement(LinkCommentResponse.serializer, item));
  }

  LinkDto deserializeLink(dynamic item) {
    return _linkDtoMapper.apply(client.deserializeElement(LinkResponse.serializer, item));
  }

  List<LinkCommentDto> deserializeLinkComments(dynamic items) {
    return client.deserializeList(LinkCommentResponse.serializer, items).map(_linkCommentDtoMapper.apply).toList();
  }
}
