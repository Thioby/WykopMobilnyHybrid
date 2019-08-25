import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:owmflutter/models/models.dart';
import 'package:owmflutter/widgets/embed_full_screen.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:owmflutter/utils/utils.dart';
import 'package:owmflutter/screens/screens.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'dart:io' show Platform;

class EmbedWidget extends StatefulWidget {
  final Embed embed;
  final double reducedWidth;
  final double borderRadius;
  final EdgeInsets padding;

  EmbedWidget({
    this.embed,
    this.reducedWidth: 0.0,
    this.borderRadius: 0.0,
    this.padding,
  });

  _EmbedState createState() => _EmbedState();
}

class _EmbedState extends State<EmbedWidget> {
  double _imageFactor = 0.0;
  bool loading = true;
  bool resized = false;
  bool nsfw = false;
  var imageResolver;
  ImageStreamListener imageSizeListener;

  @override
  void initState() {
    super.initState();
    imageSizeListener =
        new ImageStreamListener((ImageInfo image, bool synchronousCall) {
      updateImageSize(image);
    });

    // First, fetch image size for sizedbox calculations
    imageResolver =
        AdvancedNetworkImage(widget.embed.preview, useDiskCache: true)
            .resolve(ImageConfiguration());
    imageResolver.addListener(this.imageSizeListener);
  }

  @override
  void dispose() {
    super.dispose();
    this.imageResolver.removeListener(this.imageSizeListener);
  }

  void updateImageSize(ImageInfo image) {
    setState(() {
      loading = false;
      _imageFactor = image.image.height / image.image.width;
      resized = false;
      nsfw = widget.embed.plus18;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          if (!resized && !loading) {
            this.setState(() {
              resized = true;
              nsfw = false;
            });
          } else if (nsfw && widget.reducedWidth == 0.0) {
            this.setState(() {
              nsfw = false;
            });
          } else {
            this.openFullscreen();
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          decoration: this.getDecoration(),
          constraints: this.currentConstraints(),
          child: nsfw && widget.reducedWidth == 0.0
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0),
                    ),
                    child: _drawFooter(),
                  ),
                )
              : _drawFooter(),
        ),
      ),
    );
  }

  Widget _drawFooter() {
    return AnimatedOpacity(
      opacity: !loading && !resized ? 1.0 : 0.0,
      duration: Duration(milliseconds: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Container()),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.borderRadius),
                bottomRight: Radius.circular(widget.borderRadius),
              ),
            ),
            padding: EdgeInsets.all(4.0),
            child: Text(
              '••• pokaż cały obrazek •••',
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
        ],
      ),
    );
  }

  // If image size is already fetched, load whole image from cache
  BoxDecoration getDecoration() {
    if (loading) {
      return BoxDecoration();
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: [BoxShadow(color: Color(0x33000000))],
      image: DecorationImage(
        image: NetworkImage(widget.embed.preview),
        alignment: FractionalOffset.topCenter,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  // Returns size - default height for loading and unresized image, full for resized image
  BoxConstraints currentConstraints() {
    double maxHeight = MediaQuery.of(context).size.height / 2.0;

    if (!loading) {
      var height = (MediaQuery.of(context).size.width - widget.reducedWidth) *
          widget.embed.ratio;

      if (!resized && height <= maxHeight) {
        this.setState(() {
          resized = true;
        });
      } else if (resized) {
        return BoxConstraints.tight(Size.fromHeight(height));
      } else {
        return BoxConstraints.tight(Size.fromHeight(maxHeight));
      }
    }

    if (loading || !resized) {
      return BoxConstraints.tight(Size.fromHeight(maxHeight));
    } else {
      return BoxConstraints.tight(Size.fromHeight(
          (MediaQuery.of(context).size.width - widget.reducedWidth) *
              widget.embed.ratio));
    }
  }

  // Open fullscreen image viewer
  void openFullscreen() {
    Navigator.push(
        context, Utils.getPageSlideToUp(MediaScreen(embed: widget.embed)));
  }
}
