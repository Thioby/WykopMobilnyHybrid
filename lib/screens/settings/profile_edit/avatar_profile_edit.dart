import 'package:flutter/material.dart';
import 'package:owmflutter/model/model.dart';
import 'package:owmflutter/screens/settings/profile_edit/input_button.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';

class AvatarProfileEdit extends StatefulWidget {
  _AvatarProfileEditState createState() => _AvatarProfileEditState();
}

class _AvatarProfileEditState extends State<AvatarProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStateModel>(
      builder: (context, authStateModel, _) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "Avatar będzie w najlepszej jakości, jeśli dodasz grafikę o minimalnych wymiarach 150×150 pixeli"),
            ),
            AvatarWidget(
              author: AuthorDto(
                  avatar: authStateModel.avatarUrl ?? "",
                  login: authStateModel.login ?? "",
                  color: authStateModel.color ?? 0),
              size: 200,
              badge: Colors.transparent,
              genderVisibility: false,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Wybierz nowy avatar:"),
                )),
                RoundIconButtonWidget(
                  icon: Icons.photo,
                  iconSize: 26.0,
                  iconPadding: EdgeInsets.all(8.0),
                ),
                RoundIconButtonWidget(
                  icon: Icons.camera_alt,
                  iconSize: 26.0,
                  iconPadding: EdgeInsets.all(8.0),
                )
              ],
            ),
            InputButtonWidget(text: "Zapisz"),
          ],
        );
      },
    );
  }
}
