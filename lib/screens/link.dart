import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:owmflutter/store/store.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:owmflutter/models/models.dart';
import 'package:owmflutter/owm_glyphs.dart';
import 'package:owmflutter/keys.dart';
import 'dart:async';

class LinkScreen extends StatelessWidget {
  final int linkId;
  LinkScreen({Key key, @required this.linkId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SystemPadding(
      child: Scaffold(
          bottomNavigationBar: StoreConnector<AppState, dynamic>(
              converter: (store) =>
                  (Completer completer, InputData inputData) => {},
              builder: (context, callback) => InputBarWidget((inputData) {
                    var completer = Completer();
                    callback(completer, inputData);
                    return completer.future;
                  }, key: OwmKeys.inputBarKey)),
          resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: AppBar(
                  title: Text('ZNALEZISKO', style: TextStyle(fontSize: 16.0)),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(OwmGlyphs.ic_refresh),
                        onPressed: () {},
                        tooltip: "Odśwież")
                  ],
                  elevation: 1.5,
                  centerTitle: true,
                  titleSpacing: 0.0)),
          body: Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).backgroundColor),
              child: StoreConnector<AppState, dynamic>(
                converter: (store) => (completer) =>
                    store.dispatch(loadLinkComments(linkId, completer)),
                builder: (context, callback) =>
                    StoreConnector<AppState, List<int>>(
                        converter: (store) =>
                            store.state.linkScreensState.states[linkId] != null
                                ? store
                                    .state.linkScreensState.states[linkId].ids
                                : [],
                        onInit: (store) {
                          store.dispatch(loadLinkComments(linkId, Completer()));
                        },
                        builder: (context, ids) {
                          return RefreshIndicator(
                            onRefresh: () {
                              var completer = new Completer();
                              callback(completer);
                              return completer.future;
                            },
                            child: ScrollConfiguration(
                              behavior: NotSuddenJumpScrollBehavior(),
                              child: ListView.builder(
                                  itemCount: ids.length,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return LinkWidget(linkId: linkId);
                                    } else {
                                      return TopLinkCommentWidget(
                                          commentId: ids[index]);
                                    }
                                  }),
                            ),
                          );
                        }),
              ))),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 150),
        child: child);
  }
}