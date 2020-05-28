import 'package:flutter/material.dart';
import 'package:owmflutter/keys.dart';
import 'package:owmflutter/screens/screens.dart';
import 'package:owmflutter/themes.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:owmflutter/widgets/notifications_handler.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:pref_gen_flutter/pref_gen_flutter.dart';
import 'package:provider/provider.dart';

import 'model/model.dart';

var owmSettings = OWMSettings(SharedPreferencesAdapter());

class OwmApp extends StatelessWidget {
  OwmApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HighlightWrapper(
      id: -1,
      child: ErrorHandlerWidget(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: AuthStateModel()),
            Provider.value(value: owmSettings),
            ChangeNotifierProvider.value(value: SuggestionsModel()),
          ],
          child: NotificationsHandler(
            child: Consumer<AuthStateModel>(
              // Required to make app redraw on login
              builder: (context, model, _) => OWMSettingListener(
                rebuildOnChange: (settings) => settings.useDarkThemeStream,
                builder: (context, settings) {
                  return OWMSettingListener(
                    rebuildOnChange: (settings) => settings.accentColorStream,
                    builder: (context, settings) => MaterialApp(
                      title: 'Wykop Mobilny',
                      navigatorKey: OwmKeys.navKey,
                      theme: settings.useDarkTheme
                          ? Themes.darkTheme(accentColor: settings.accentColor)
                          : Themes.lightTheme(accentColor: settings.accentColor),
                      routes: {
                        '/': (context) => MainScreen(),
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
