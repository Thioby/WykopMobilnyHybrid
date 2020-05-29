import 'package:equatable/equatable.dart';
import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/data/mapper/mapper.dart';

class EntryMediaDto implements Equatable {
  final String preview;
  final String url;
  final String type;
  final String source;
  final String size;
  final double ratio;
  final bool isAnimated;
  final bool plus18;

  EntryMediaDto({this.preview, this.url, this.type, this.source, this.size, this.ratio, this.isAnimated, this.plus18});

  @override
  List<Object> get props => [url, type];

  @override
  bool get stringify => true;
}

class EntryMediaResponseToEntryMediaDtoMapper implements DataMapper<EmbedResponse, EntryMediaDto> {
  @override
  EntryMediaDto apply(EmbedResponse response) {

    if(response == null) {
      return null;
    }
    // TODO: implement apply
    return EntryMediaDto(
        preview: response.preview,
        url: response.url,
        plus18: response.plus18,
        type: response.type,
        size: response.size,
        source: response.source,
        ratio: response.ratio,
        isAnimated: response.animated);
  }
}
