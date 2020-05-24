import 'package:built_value/built_value.dart';
import 'package:owmflutter/models/models.dart';
import 'package:wykop_api/api/api.dart';

part 'profile_related.g.dart';

abstract class ProfileRelated
    implements Built<ProfileRelated, ProfileRelatedBuilder> {
  int get id;

  String get url;

  String get title;

  @nullable
  @BuiltValueField(wireName: 'vote_count')
  int get voteCount;

  factory ProfileRelated.mapFromResponse(ProfileRelatedResponse response) {
    return _$ProfileRelated._(
      id: response.id,
      url: response.url,
      title: response.title,
      voteCount: response.voteCount,
    );
  }

  ProfileRelated._();
}
