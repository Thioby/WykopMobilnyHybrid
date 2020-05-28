import 'package:wykop_api/api/api.dart';
import 'package:wykop_api/api/response_models/voter_response.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/EntryCommentDto.dart';
import 'package:wykop_api/data/model/EntryDto.dart';
import 'package:wykop_api/data/model/EntryLinkDto.dart';
import 'package:wykop_api/data/model/LinkCommentDto.dart';
import 'package:wykop_api/data/model/LinkDto.dart';
import 'package:wykop_api/data/model/NotificationDto.dart';
import 'package:wykop_api/data/model/ProfileRelatedDto.dart';
import 'package:wykop_api/data/model/RelatedDto.dart';
import 'package:wykop_api/data/model/VoterDto.dart';

abstract class ApiResource {
  ApiClient _client;
  ApiClient get client => _client;

  ApiResource(
    ApiClient client,
  ) {
    this._client = client;
  }


}
