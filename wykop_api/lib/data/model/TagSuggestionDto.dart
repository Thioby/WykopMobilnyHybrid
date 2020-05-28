import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';

class TagSuggestionDto implements Equatable {
  final String tag;
  final int followers;

  TagSuggestionDto({this.tag, this.followers});

  @override
  // TODO: implement props
  List<Object> get props => [tag, followers];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}

class TagSuggestionResponseToTagSuggestionDtoMapper implements DataMapper<TagSuggestionResponse, TagSuggestionDto> {
  @override
  TagSuggestionDto apply(TagSuggestionResponse response) {
    return TagSuggestionDto(tag: response.tag, followers: int.parse(response.followers)) ?? 0;
  }
}
