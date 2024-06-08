import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final String? path;
  final IconData? iconData;
  final double size;

  final Color? color;
  final EdgeInsetsGeometry margin;
  final bool square;

  const AppIcon({
    Key? key,
    this.path,
    this.iconData,
    this.size = 28,
    this.color,
    this.margin = EdgeInsets.zero,
    this.square = true,
  })  : assert((path != null) ^ (iconData != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: iconData != null
          ? Icon(iconData, size: size, color: color)
          : ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                height: square ? size : null,
                width: size,
              ),
              child: path!.endsWith('.svg')
                  ? SvgPicture.asset(path!, color: color, width: size)
                  : Image.asset(path!, color: color),
            ),
    );
  }

  AppIcon apply({
    double? size,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) =>
      AppIcon(
        path: path,
        iconData: iconData,
        size: size ?? this.size,
        color: color ?? this.color,
        margin: margin ?? this.margin,
        square: square,
      );
}

class AppIcons {
  static const appIcon = AppIcon(
    path: 'assets/icons/app_icon.png',
    size: 150,
  );
}
