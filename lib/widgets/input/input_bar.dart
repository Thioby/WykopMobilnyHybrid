import 'package:flutter/material.dart';
import 'package:owmflutter/owm_glyphs.dart';
import 'package:owmflutter/models/models.dart';
import 'package:owmflutter/keys.dart';
import 'dart:async';

typedef Future InputBarCallback(InputData inputData);

class InputBarWidget extends StatefulWidget {
  final InputBarCallback callback;
  InputBarWidget(this.callback, {@required Key key}) : super(key: key);
  InputBarWidgetState createState() => InputBarWidgetState();
}

class InputBarWidgetState extends State<InputBarWidget> {
  bool showMarkdownBar = false;
  bool showMediaButton = true;
  bool clickTextField = false;
  bool isEmpty = true;
  bool sending = false;
  final FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

  void replyToUser(Author author) {
    _ensureFocus();
    setState(() {
      textController.text += "@" + author.login + ": ";
      textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
    });
  }

  void _ensureFocus() {
    if (!focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(focusNode);
    }
  }

  void quoteText(Author author, String body) {
    _ensureFocus();
    setState(() {
      textController.text += "@" + author.login + ": \n" + "> " + body + "\n";
      textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
    });
  }

  // Returns currently selected text or placeholder for markdown actions
  String getSelectedText() {
    if (textController.selection.start != textController.selection.end) {
      return textController.text.substring(
          textController.selection.start, textController.selection.end);
    } else {
      return "tekst";
    }
  }

  // Inserts given prefix and suffix to currently selected text
  void insertSelectedText(String prefix, {String suffix = ""}) {
    _ensureFocus();
    var initialSelectionStart = textController.selection.start;
    var text = getSelectedText();
    setState(() {
      textController.text =
          textController.text.substring(0, textController.selection.start) +
              prefix +
              text +
              suffix +
              textController.text.substring(
                  textController.selection.end, textController.text.length);
      textController.selection = TextSelection(
          baseOffset: initialSelectionStart + prefix.length,
          extentOffset: initialSelectionStart + text.length + prefix.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: BottomAppBar(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_drawInputBar(), _drawButtons()])));
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(() => _watchTextChanges());
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  _watchTextChanges() {
    if (textController.text != null && textController.text.length >= 3) {
      if (isEmpty) {
        setState(() {
          isEmpty = false;
        });
      }
    } else if (!isEmpty) {
      setState(() {
        isEmpty = true;
      });
    }
  }

  Widget _drawInputBar() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          _drawShowMarkdownButton(),
          _drawMediaButton(),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 6.0),
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 1.0, right: 1.0, bottom: 1.0),
                  decoration: BoxDecoration(
                      color: Color(0x267f7f7f),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(16.0))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 90.0),
                                child: Scrollbar(
                                    child: SingleChildScrollView(
                                        reverse: true,
                                        child: TextField(
                                            focusNode: focusNode,
                                            cursorWidth: 2,
                                            cursorRadius: Radius.circular(20.0),
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .merge(
                                                    TextStyle(fontSize: 14.0)),
                                            maxLines: null,
                                            controller: this.textController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            onTap: () {
                                              setState(() {
                                                showMediaButton = false;
                                                clickTextField = true;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                border: InputBorder.none,
                                                hintText:
                                                    'Treść komentarza')))))),
                        _drawEmoticonButton()
                      ]))),
          _drawSendButton()
        ]));
  }

  Widget _drawButtons() {
    if (showMarkdownBar) {
      return Container(
          //color: Theme.of(context).backgroundColor,
          padding: const EdgeInsets.only(bottom: 8.0, left: 6.0, right: 6.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _drawIconRound(Icons.format_bold, () {
                  insertSelectedText("**", suffix: "**");
                }),
                _drawIconRound(Icons.format_italic,
                    () => insertSelectedText("_", suffix: "_")),
                _drawIconRound(Icons.format_quote,
                    () => insertSelectedText("\n> ", suffix: "\n")),
                _drawIconRound(
                    Icons.link,
                    () =>
                        insertSelectedText("[", suffix: "](https://wykop.pl)")),
                _drawIconRound(
                    Icons.code, () => insertSelectedText("`", suffix: "`")),
                _drawIconRound(OwmGlyphs.ic_markdowntoolbar_spoiler,
                    () => insertSelectedText("\n! ", suffix: "\n")),
                _drawIconRound(Icons.format_list_bulleted, () => {}),
                _drawIconRound(Icons.image, () {}),
                _drawIconRound(Icons.fullscreen, () {})
              ]));
    } else {
      return Container();
    }
  }

  void _sendButtonClicked() {
    setState(() {
      this.sending = true;
    });
    this
        .widget
        .callback(InputData(body: this.textController.text))
        .then((_) => setState(() {
              this.sending = false;
              this.textController.clear();
            }));
  }

  Widget _drawShowMarkdownButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 6.0),
      child: InkWell(
          onTap: () {
            setState(() {
              showMarkdownBar = showMarkdownBar ? false : true;
              showMediaButton =
                  showMarkdownBar ? false : clickTextField ? false : true;
            });
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                  showMarkdownBar ? Icons.remove_circle : Icons.add_circle,
                  size: 26.0,
                  color: Colors.blueAccent))),
    );
  }

  Widget _drawMediaButton() {
    if (showMediaButton) {
      return Container(
        padding: EdgeInsets.only(bottom: 6.0),
        child: InkWell(
            onTap: () {
              // PhotoBottomSheetWidget();
            },
            borderRadius: BorderRadius.circular(100.0),
            child: Padding(
                padding: const EdgeInsets.all(6.0),
                child:
                    Icon(Icons.image, size: 26.0, color: Colors.blueAccent))),
      );
    } else {
      return Container();
    }
  }

  Widget _drawEmoticonButton() {
    return InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(100.0),
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.mood, color: Colors.blueAccent)));
  }

  Widget _drawSendButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 6.0),
      child: InkWell(
          onTap: () {
            this._sendButtonClicked();
          },
          borderRadius: BorderRadius.circular(100.0),
          child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: sending
                  ? CircularProgressIndicator()
                  : Icon(Icons.send,
                      size: 26.0,
                      color: isEmpty ? Colors.grey : Colors.blueAccent))),
    );
  }

  Widget _drawIconRound(IconData iconData, VoidCallback onClick) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Color(0x337f7f7f), width: 1.0)),
        child: InkWell(
            onTap: onClick,
            borderRadius: BorderRadius.circular(100.0),
            child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(iconData, size: 18.0))));
  }
}
