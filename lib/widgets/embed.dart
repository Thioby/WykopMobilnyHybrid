import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:owmflutter/screens/screens.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import 'package:wykop_api/infrastucture/data/model/EntryMediaDto.dart';

final Uint8List kTransparentImage = new Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);

class EmbedWidget extends StatefulWidget {
  final EntryMediaDto embed;
  final double reducedWidth;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isNsfwTag;
  final ImageType type;

  EmbedWidget({
    this.embed,
    this.reducedWidth: 0.0,
    this.borderRadius: 0.0,
    this.padding,
    this.type,
    this.isNsfwTag = false,
  });

  _EmbedState createState() => _EmbedState();
}

enum ImageType {
  ENTRY,
  COMMENT,
}

class _EmbedState extends State<EmbedWidget> {
  bool resized = false;
  bool nsfw = false;
  bool hide = false;

  @override
  void initState() {
    super.initState();
    var settings = Provider.of<OWMSettings>(context, listen: false);
    nsfw = widget.embed.plus18 || widget.isNsfwTag;
    hide = widget.type == ImageType.COMMENT && settings.hiddingCommentImage ||
        widget.type == ImageType.ENTRY && settings.hiddingEntryImage;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          if (hide) {
            setState(() {
              hide = false;
            });
            return;
          }
          if (!resized) {
            if ((!nsfw && Provider.of<OWMSettings>(context, listen: false).skipExpandImage) ||
                (nsfw &&
                    Provider.of<OWMSettings>(context, listen: false).skipShowAdultImage)) {
              openFullscreen();
            } else {
              setState(() {
                resized = true;
                nsfw = false;
              });
            }
          } else if (nsfw) {
            if (Provider.of<OWMSettings>(context, listen: false).skipShowAdultImage) {
              openFullscreen();
            } else {
              setState(() => nsfw = false);
            }
          } else {
            openFullscreen();
          }
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 2.0,
              bottom: 2.0,
              right: 0.0,
              left: 0.0,
              child: Center(child: CircularProgressIndicator()),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              decoration: _getDecoration(),
              constraints: _currentConstraints(),
              child: _drawFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawPlaceholder() {
    return Visibility(
      visible: nsfw && Provider.of<OWMSettings>(context).hideAdultImage || hide,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor.withOpacity(0.96),
              Theme.of(context).accentColor
            ],
          ),
        ),
        child: Center(
          child: Text(
            hide ? "IMG" : "NSFW",
            style: TextStyle(
              fontSize:
                  (MediaQuery.of(context).size.width - widget.reducedWidth) /
                      5.0,
              letterSpacing: 6.0,
              fontWeight: FontWeight.bold,
              color: Utils.backgroundGreyOpacity(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawFooter() {
    return Stack(
      children: [
        Visibility(
          visible: widget.embed.isAnimated || widget.embed.type != "image",
          child: Center(
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Utils.backgroundGrey(context),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6.0,
                    offset: Offset(0.0, 1.0),
                    color: Colors.black38,
                  )
                ],
              ),
              child: Icon(Icons.play_arrow, size: 32.0),
            ),
          ),
        ),
        Positioned(
          child: _drawPlaceholder(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: !resized ? 1.0 : 0.0,
            duration: Duration(milliseconds: 100),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.borderRadius),
                  bottomRight: Radius.circular(widget.borderRadius),
                ),
              ),
              padding: EdgeInsets.all(4.0),
              child: Text(
                '••• kliknij, aby rozwinąć obrazek •••',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title.copyWith(
                  fontSize: 11.0,
                  shadows: [
                    Shadow(
                      blurRadius: 1.5,
                      color: Theme.of(context).backgroundColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // If image size is already fetched, load whole image from cache
  BoxDecoration _getDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: [
        BoxShadow(color: Theme.of(context).iconTheme.color.withOpacity(0.15))
      ],
      image: DecorationImage(
        image: hide
            ? MemoryImage(kTransparentImage)
            : NetworkImage(Provider.of<OWMSettings>(context, listen: false).highResImage
                ? widget.embed.preview.replaceAll(",w400.jpg", ",w600.jpg")
                : widget.embed.preview),
        alignment: FractionalOffset.topCenter,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  // Returns size - default height for loading and unresized image, full for resized image
  BoxConstraints _currentConstraints() {
    double maxHeight = MediaQuery.of(context).size.height / 2.0;
    double height =
        (MediaQuery.of(context).size.width - (widget.reducedWidth + 1.0)) *
            widget.embed.ratio;

    if ((!resized && height <= maxHeight) ||
        !Provider.of<OWMSettings>(context).shortLongPicture) {
      setState(() => resized = true);
    } else if (resized) {
      return BoxConstraints.tight(Size.fromHeight(height));
    } else {
      return BoxConstraints.tight(Size.fromHeight(maxHeight));
    }

    if (!resized) {
      return BoxConstraints.tight(Size.fromHeight(maxHeight));
    } else {
      return BoxConstraints.tight(Size.fromHeight(height));
    }
  }

  // Open fullscreen image viewer
  void openFullscreen() {
    if (Provider.of<OWMSettings>(context, listen: false).imageOpenBrowser) {
      launchDefaultBrowser(widget.embed.url);
      return;
    }
    Navigator.push(
        context, Utils.getPageSlideToUp(MediaScreen(embed: widget.embed)));
  }
}
