import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:mime/mime.dart';
import 'package:owmflutter/model/input_model.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart' as share;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as Path;
import 'package:wykop_api/data/model/PmMessageDto.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key key,
    @required this.message,
  }) : super(key: key);

  final PmMessageDto message;

  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with TickerProviderStateMixin {
  bool showDateState = false;
  bool showButtonsState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 18.0),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _drawDate(),
              Column(
                crossAxisAlignment: widget.message.isSentFromUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showDateState = !showDateState;
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        if (widget.message.body == null ||
                            widget.message.body == "​​​​​") {
                          showDateState = !showDateState;
                        }
                        showButtonsState = !showButtonsState;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      margin: EdgeInsets.only(
                        left: widget.message.isSentFromUser ? 60.0 : 0.0,
                        right: widget.message.isSentFromUser ? 0.0 : 60.0,
                        bottom: showButtonsState ? 40.0 : 0.0,
                      ),
                      constraints: BoxConstraints.loose(
                        Size(
                            MediaQuery.of(context).size.width, double.infinity),
                      ),
                      decoration: BoxDecoration(
                        color: widget.message.isSentFromUser
                            ? Theme.of(context).accentColor
                            : Utils.backgroundGreyOpacity(context),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          BodyWidget(
                            textSize: 15.0,
                            textColor: widget.message.isSentFromUser
                                ? Colors.white
                                : Theme.of(context).textTheme.body1.color,
                            linkColor: widget.message.isSentFromUser
                                ? Colors.white
                                : Theme.of(context).accentColor,
                            body: widget.message.body,
                            ellipsize: false,
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 14.0,
                            ),
                          ),
                          _drawEmbed(widget.message),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: widget.message.isSentFromUser ? null : 0.0,
            right: widget.message.isSentFromUser ? 0.0 : null,
            child: IgnorePointer(
              ignoring: !showButtonsState,
              child: AnimatedOpacity(
                opacity: showButtonsState ? 1 : 0,
                curve: Curves.linearToEaseOut,
                duration: Duration(milliseconds: 300),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[800],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            offset: Offset(0.0, 1.0),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Consumer<InputModel>(
                        builder: (context, inputModel, _) => Row(
                          children: <Widget>[
                            _drawButtons(
                              Icons.share,
                              onTap: widget.message.embed != null
                                  ? () async {
                                      // @TODO: Move it somewhere
                                      var request = await HttpClient().getUrl(
                                          Uri.parse(widget.message.embed.url));
                                      var response = await request.close();
                                      Uint8List bytes =
                                          await consolidateHttpClientResponseBytes(
                                              response);
                                      await Share.file(
                                          'Udostępnij obrazek',
                                          Path.basename(
                                              widget.message.embed.url),
                                          bytes,
                                          lookupMimeType(Path.basename(
                                              widget.message.embed.url)),
                                          text: widget.message.body ?? "");
                                    }
                                  : () {
                                      share.Share.share(
                                          parse(widget.message.body ?? "")
                                              .documentElement
                                              .text);
                                    },
                              title: "Udostępnij",
                            ),
                            _drawButtons(
                              Icons.format_quote,
                              visible: widget.message.body != null &&
                                  widget.message.body != "​​​​​",
                              onTap: () => inputModel.inputBarKey.currentState
                                  .quoteText(parse(widget.message.body ?? "")
                                      .documentElement
                                      .text),
                              title: "Cytuj",
                            ),
                            _drawButtons(
                              Icons.content_copy,
                              visible: widget.message.body != null &&
                                  widget.message.body != "​​​​​",
                              onTap: () => Utils.copyToClipboard(
                                  context,
                                  parse(widget.message.body ?? "")
                                      .documentElement
                                      .text),
                              title: "Kopiuj treść",
                            ),
                            _drawButtons(
                              Icons.file_download,
                              visible: widget.message.embed != null,
                              onTap: () async {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Zapisywanie obrazka")));
                                await ImageDownloader.downloadImage(
                                    widget.message.embed.url);
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Obrazek został zapisany")));
                              },
                              title: "Zapisz obrazek",
                            ),
                          ],
                        ),
                      ),
                    ),
                    _drawButtonClose()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawDate() {
    return AnimatedContainer(
      alignment: Alignment.topCenter,
      curve: Curves.linearToEaseOut,
      height: showDateState ? 16.0 : 0.0,
      duration: Duration(milliseconds: 400),
      child: Text(
        Utils.getDateFormat(
            widget.message.date, '\'Wysłano\' dd.MM.yyyy \'o\' HH:mm:ss'),
        style: TextStyle(
          color: Theme.of(context).textTheme.caption.color,
          fontSize: 11.0,
        ),
      ),
    );
  }

  Widget _drawButtons(
    IconData icon, {
    double size = 18.0,
    bool visible = true,
    VoidCallback onTap,
    String title,
  }) {
    return Visibility(
      visible: visible,
      child: Tooltip(
        message: title ?? "",
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap ?? () {},
            child: Container(
              padding: EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Utils.backgroundGreyOpacity(context),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Icon(icon, size: size),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawButtonClose() {
    return Tooltip(
      message: "Ukryj",
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (widget.message.body == null || widget.message.body == "​​​​​") {
              showDateState = !showDateState;
            }
            showButtonsState = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.grey[800],
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 1.0),
              ),
            ],
          ),
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(right: 12.0),
          child: Icon(
            Icons.close,
            size: 28.0,
          ),
        ),
      ),
    );
  }

  Widget _drawEmbed(PmMessageDto entry) {
    return Visibility(
      visible: entry.embed != null,
      child: EmbedWidget(
        embed: entry.embed,
        borderRadius: 20.0,
        reducedWidth: 96.0,
      ),
    );
  }
}
