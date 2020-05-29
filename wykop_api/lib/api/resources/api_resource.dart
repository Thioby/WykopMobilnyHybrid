import 'package:wykop_api/api/client.dart';

abstract class ApiResource {
  ApiClient _client;
  ApiClient get client => _client;

  ApiResource(
    ApiClient client,
  ) {
    this._client = client;
  }
}
