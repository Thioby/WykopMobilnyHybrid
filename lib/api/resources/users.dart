import 'package:owmflutter/api/api.dart';
import 'package:built_collection/built_collection.dart';
import 'package:owmflutter/models/models.dart';

class UsersApi extends ApiResource {
  UsersApi(ApiClient client) : super(client);

  Future<UserProfile> login(String login, String accountKey) async {
    var result = await client.request('login', 'index',
        post: {'login': login, 'accountkey': accountKey});

    var credentials = AuthCredentials(
        avatarUrl: result["profile"]["avatar"],
        login: login,
        token: accountKey,
        refreshToken: result["userkey"]);
    await saveAuthCreds(credentials);
    client.credentials = credentials;

    return UserProfile(avatarUrl: result["profile"]["avatar"], login: login);
  }
}