import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owmflutter/app.dart';
import 'package:owmflutter/widgets/notifications_handler.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:owmflutter/main.dart';
import 'package:wykop_api/domain/api_secrets_provider.dart';
import 'package:wykop_api/domain/secrets/api_secrets.dart';
import 'package:wykop_api/infrastucture/api.dart';
import 'package:wykop_api/infrastucture/client.dart';

void main() {
  timeago.setLocaleMessages('pl', timeago.PlMessages());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(RestartWidget(child: OwmApp()));

  print("OKEEEEJ");
  BackgroundFetch.registerHeadlessTask(fetchNotificationsTask);
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state = context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }
}

class AssetsSecretsLoader implements ApiSecretsProvider {
  @override
  Future<ApiSecrets> loadSecrets() async {
    var rawJson = await rootBundle.loadString('assets/secrets.json');
    var decoded = json.decode(rawJson);
    return ApiSecrets(appkey: decoded["wykop_key"], secret: decoded["wykop_secret"]);
  }
}

var api =
    ApiInitializer().initialize((ApiClientBuilder()..secretsProvider = AssetsSecretsLoader()).build()).getApiClient();
