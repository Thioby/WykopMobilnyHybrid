import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wykop_api/api/api.dart';
import 'package:owmflutter/keys.dart';

class ErrorHandlerWidget extends StatefulWidget {
  final Widget child;

  ErrorHandlerWidget({this.child, Key key}) : super(key: key);

  _ErrorHandlerWidgetState createState() => _ErrorHandlerWidgetState();
}

class _ErrorHandlerWidgetState extends State<ErrorHandlerWidget> {
  StreamSubscription<Error> _sub;

  @override
  void initState() {
    api.errorStreamController.close();
    api.errorStreamController = StreamController<Error>();
    this._sub = api.errorStream.listen((e)  {
      var rightContext = OwmKeys.navKey.currentState.overlay.context;
          showDialog(
              context: rightContext,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Coś poszło nie tal :("),
                  content: new Text(e.toString()),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("No cóz"),
                      onPressed: () {
                        Navigator.of(rightContext).pop();
                      },
                    ),
                  ],
                );
              },);
        });

    super.initState();
  }

  @override
  void dispose() {
    api.errorStreamController.sink.close();
    api.errorStreamController.close();
    this._sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
