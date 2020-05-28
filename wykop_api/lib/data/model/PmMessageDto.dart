import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';
import 'package:wykop_api/data/model/EntryMediaDto.dart';

class PmMessageDto implements Equatable {
  final String date;
  final String body;
  final EntryMediaDto embed;
  final bool isSentFromUser;
  final String app;

  PmMessageDto({
    this.date,
    this.body,
    this.embed,
    this.isSentFromUser,
    this.app,
  });

  @override
  List<Object> get props => [date, body];

  @override
  bool get stringify => true;
}

class PmMessageResponseToPmMessageDtoMapper implements DataMapper<PmMessageResponse, PmMessageDto> {
  final EntryMediaResponseToEntryMediaDtoMapper _entryMediaDtoMapper;

  PmMessageResponseToPmMessageDtoMapper(this._entryMediaDtoMapper);
  @override
  PmMessageDto apply(PmMessageResponse response) {
    return PmMessageDto(
      date: response.date,
      embed: _entryMediaDtoMapper.apply(response.embed),
      body: response.body,
      isSentFromUser: response.direction != "received",
      app: response.app,
    );
  }
}
