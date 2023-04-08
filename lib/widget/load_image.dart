import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurent_user/res/colors.dart';
import 'package:restaurent_user/util/image_util.dart';
import 'package:restaurent_user/util/screen_utill.dart';
import 'package:restaurent_user/widget/loader.dart';

class LoadImage extends StatelessWidget {
  const LoadImage(
    this.image, {
    this.radius,
    Key? key,
  })  : assert(image != null, 'The [image] argument must not be null.'),
        super(key: key);

  final String image;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    print(radius.toString());
    return CachedNetworkImage(
      fit: BoxFit.cover,
      color: Colors.transparent,
      fadeInCurve: Curves.bounceIn,
      fadeInDuration: Duration(milliseconds: 500),
      placeholder: (_, __) => CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(
          'assets/none.png',
        ),
      ),
      imageUrl: image,
      imageBuilder: (context, img) => CircleAvatar(
        radius: radius,
        backgroundImage: img,
      ),
    );
  }
}

class LoadRectImage extends StatelessWidget {
  const LoadRectImage(
    this.image, {
    this.height,
    this.width,
    Key? key,
  })  : assert(image != null, 'The [image] argument must not be null.'),
        super(key: key);

  final String image;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      color: Colors.transparent,
      fadeInCurve: Curves.bounceIn,
      fadeInDuration: Duration(milliseconds: 500),
      placeholder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/none.png',
            ),
          ),
        ),
      ),
      imageUrl: image,
      imageBuilder: (context, img) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: img,
          ),
        ),
      ),
    );
  }
}

class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(this.image,
      {Key? key,
      this.width,
      this.height,
      this.cacheWidth,
      this.cacheHeight,
      this.fit,
      this.format = ImageFormat.png,
      this.color})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat? format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageUtils.getImgPath(image, format: format!),
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      excludeFromSemantics: true,
    );
  }
}

class ImageAddRemove {
  static Stack displayImage(var _image, VoidCallback removedImage, context) {
    return Stack(
      children: [
        Center(
          child: CircleAvatar(
              radius: Screen.width(context) * 0.2,
              backgroundImage: Image.file(
                _image,
                fit: BoxFit.cover,
              ).image,
              backgroundColor: Colors.transparent,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  child: Text(
                    'removed img',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: removedImage,
                ),
              )),
        ),
      ],
    );
  }

  static Widget addImage(BuildContext context, Function getImage) {
    bool _isLoading = false;

    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: Screen.width(context) * 0.2,
        backgroundColor: Colours.app_main,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colours.accent,
              ),
              onPressed: () async {
                await getImage();
              },
            ),
            Text(
              'profile',
              style: TextStyle(color: Colours.accent),
              // softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}

class AddImage extends StatefulWidget {
  final BuildContext? context;
  final Function? getImage;
  const AddImage({Key? key, this.context, this.getImage}) : super(key: key);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: Screen.width(context) * 0.2,
        backgroundColor: Colours.app_main,
        child: (_isLoading)
            ? loader
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colours.accent,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await widget.getImage!();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                  Text(
                    'profile',
                    style: TextStyle(color: Colours.accent),
                    // softWrap: true,
                  ),
                ],
              ),
      ),
    );
  }
}

class DisplayNetWorkImg extends StatefulWidget {
  DisplayNetWorkImg({
    Key? key,
    @required image,
    required this.removedImage,
    @required this.context,
    required this.imgType,
  })  : _image = image,
        super(key: key);

  final _image;
  final Function removedImage;
  final context;
  final String imgType;

  @override
  _DisplayNetWorkImgState createState() => _DisplayNetWorkImgState();
}

class _DisplayNetWorkImgState extends State<DisplayNetWorkImg> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
                backgroundColor: Colours.app_main,
                radius: Screen.width(context) * 0.2,
                child: (_isLoading)
                    ? loader
                    : LoadImage(
                        widget._image,
                        radius: Screen.width(context) * 0.2,
                      )),
          ),
          (_isLoading)
              ? Container()
              : Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: Screen.width(context) * 0.3),
                  child: FlatButton(
                    child: Text(
                      (widget.imgType == null) ? 'removed img' : widget.imgType,
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await widget.removedImage();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                )
        ],
      ),
    );
  }
}
