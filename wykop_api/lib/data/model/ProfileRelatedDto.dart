import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';

class ProfileRelatedDto implements Equatable {
  final int id;
  final String url;

  final String title;

  final int voteCount;

  ProfileRelatedDto({
    this.id,
    this.url,
    this.title,
    this.voteCount,
  });

  @override
  List<Object> get props => [id];

  @override
  bool get stringify => true;
}

class ProfileRelatedResponseToRelatedDtoMapper implements DataMapper<ProfileRelatedResponse, ProfileRelatedDto> {
  @override
  ProfileRelatedDto apply(ProfileRelatedResponse response) {
    return ProfileRelatedDto(
      id: response.id,
      url: response.url,
      title: response.title,
      voteCount: response.voteCount,
    );
  }
}
