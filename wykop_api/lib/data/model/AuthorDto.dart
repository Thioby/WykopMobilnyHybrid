import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';

enum AuthorSexDto {
  MALE,
  FEMALE,
  OTHER,
}

class AuthorDto implements Equatable {
  final int color;
  final String avatar;
  final String login;
  final AuthorSexDto sex;

  AuthorDto({this.color, this.avatar, this.login, this.sex});

  @override
  List<Object> get props => [login];

  @override
  bool get stringify => true;
}

class AuthorResponseToAuthorDtoMapper implements DataMapper<AuthorResponse, AuthorDto> {
  @override
  AuthorDto apply(AuthorResponse response) {
    return AuthorDto(
        color: response.color.toInt(),
        avatar: response.avatar,
        login: response.login,
        sex: response.sex == null ? AuthorSexDto.OTHER : (response.sex == "male" ? AuthorSexDto.MALE : AuthorSexDto.FEMALE));
  }
}