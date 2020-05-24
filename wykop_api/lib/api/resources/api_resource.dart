import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/api/response_models/voter_response.dart';

abstract class ApiResource {
  ApiClient _client;
  ApiClient get client => _client;

  ApiResource(ApiClient client) {
    this._client = client;
  }

  List<Entry> deserializeEntries(dynamic items) {
    return _client.deserializeList(EntryResponse.serializer, items).map((e) => Entry.mapFromResponse(e)).toList();
  }

  List<Link> deserializeLinks(dynamic items) {
    return _client.deserializeList(LinkResponse.serializer, items).map((e) => Link.mapFromResponse(e)).toList();
  }

  LinkComment deserializeLinkComment(dynamic item) {
    return LinkComment.mapFromResponse(_client.deserializeElement(LinkCommentResponse.serializer, item));
  }

  EntryComment deserializeEntryComment(dynamic item) {
    return EntryComment.mapFromResponse(_client.deserializeElement(EntryCommentResponse.serializer, item));
  }

  Entry deserializeEntry(dynamic item) {
    return Entry.mapFromResponse(_client.deserializeElement(EntryResponse.serializer, item));
  }

  Link deserializeLink(dynamic item) {
    return Link.mapFromResponse(_client.deserializeElement(LinkResponse.serializer, item));
  }

  Author deserializeAuthor(dynamic item) {
    return Author.fromResponse(response: _client.deserializeElement(AuthorResponse.serializer, item));
  }

  ProfileResponse deserializeProfile(dynamic item) {
    return _client.deserializeElement(ProfileResponse.serializer, item);
  }

  List<EntryLink> deserializeEntryLinks(dynamic items) {
    return _client
        .deserializeList(EntryLinkResponse.serializer, items)
        .map((e) => EntryLink.mapFromResponse(e))
        .toList();
  }

  List<Voter> deserializeUpvoters(dynamic items) {
    return _client
        .deserializeList(VoterResponse.serializer, items)
        .map((e) => Voter.fromResponse(response: e))
        .toList();
  }

  List<Notification> deserializeNotifications(dynamic items) {
    return _client
        .deserializeList(NotificationResponse.serializer, items)
        .map((e) => Notification.mapFromResponse(e))
        .toList();
  }

  List<LinkComment> deserializeLinkComments(dynamic items) {
    return _client
        .deserializeList(LinkCommentResponse.serializer, items)
        .map((e) => LinkComment.mapFromResponse(e))
        .toList();
  }

  List<EntryComment> deserializeEntryComments(dynamic items) {
    return _client
        .deserializeList(EntryCommentResponse.serializer, items)
        .map((e) => EntryComment.mapFromResponse(e))
        .toList();
  }

  List<Related> deserializeRelatedLinks(dynamic items) {
    print(items);

    return _client.deserializeList(RelatedResponse.serializer, items).map((e) => Related.mapFromResponse(e)).toList();
  }

  List<ProfileRelated> deserializeProfileRelated(dynamic items) {
    return _client
        .deserializeList(ProfileRelatedResponse.serializer, items)
        .map((e) => ProfileRelated.mapFromResponse(e))
        .toList();
  }
}
