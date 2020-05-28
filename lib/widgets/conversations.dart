import 'package:flutter/material.dart';
import 'package:wykop_api/api/api.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:owmflutter/screens/screens.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:wykop_api/data/model/AuthorDto.dart';
import 'package:wykop_api/data/model/ConversationDto.dart';

class ConversationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShadowNotificationListener(
      child: FutureBuilder<List<ConversationDto>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var conversation = snapshot.data[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      Utils.getPageTransition(
                        PmScreen(receiver: conversation.author.login),
                      ),
                    );
                  },
                  child: AuthorWidget(
                    author: AuthorDto(
                      login: conversation.author.login,
                      avatar: conversation.author.avatar,
                      color: 5,
                      sex: conversation.author.sex,
                    ),
                    date: conversation.lastUpdate,
                    fontSize: 16.0,
                    avatarSize: 52.0,
                    padding: EdgeInsets.only(
                      top: 6.0,
                      bottom: 6.0,
                      left: 14.0,
                      right: 18.0,
                    ),
                    showUserDialog: false,
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: api.pm.getConversations(),
      ),
    );
  }
}
