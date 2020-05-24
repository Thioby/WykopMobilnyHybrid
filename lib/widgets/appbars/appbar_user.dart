import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owmflutter/screens/screens.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:wykop_api/model/model.dart';

typedef void LoginCallback(String login, String token, Completer completer);

class AppbarUserWidget extends StatelessWidget {
  final double size;
  final EdgeInsets margin;

  AppbarUserWidget({
    this.size: 36.0,
    this.margin: const EdgeInsets.symmetric(horizontal: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Consumer<AuthStateModel>(
        builder: (context, authState, _) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(Utils.getPageSlideToUp(MainSettingsScreen())),
            child: Stack(
              children: <Widget>[
                Container(
                  width: size,
                  height: size,
                  padding: EdgeInsets.all(size / 4.5),
                  decoration: BoxDecoration(
                    color: Utils.backgroundGreyOpacity(context),
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).iconTheme.color),
                    strokeWidth: size / 18.0,
                  ),
                ),
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: authState.loggedIn ? NetworkImage(authState.avatarUrl) : AssetImage('assets/avatar.png'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
