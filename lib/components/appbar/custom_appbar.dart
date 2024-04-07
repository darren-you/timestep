import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget {
  final double? height;
  final Color? stateBarBackgroundColor;
  final Brightness? stateBarContentColor;
  final Color? color;
  final Widget? child;

  const CustomAppBar({
    super.key,
    this.height,
    this.stateBarBackgroundColor = Colors.transparent,
    this.stateBarContentColor = Brightness.dark,
    this.color = Colors.white24,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var stateHeight = context.mediaQueryPadding.top;

    return Positioned(
      top: 0,
      child: Container(
        padding: EdgeInsets.only(top: stateHeight), // 设置顶部 AppBar 的顶部内边距为状态栏的高
        width: width,
        // height: height == null
        //     ? (AppBarOptions.hight50.height + stateHeight)
        //     : (height! + stateHeight),
        color: color,
        child: child,
      ),
    );
  }
}
