import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';

class AuthorSuggestionDto implements Equatable {
  final int color;
  final String avatar;
  final String login;

  AuthorSuggestionDto({
    this.color,
    this.avatar,
    this.login,
  });

  @override
  // TODO: implement props
  List<Object> get props => [login, avatar, color];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}

class AuthorSuggestionResponseToAuthorSuggestionDtoMapper
    implements DataMapper<AuthorSuggestionResponse, AuthorSuggestionDto> {
  @override
  AuthorSuggestionDto apply(AuthorSuggestionResponse response) {
    return AuthorSuggestionDto(
      color: response.color,
      avatar: response.avatar,
      login: response.login,
    );
  }
}
