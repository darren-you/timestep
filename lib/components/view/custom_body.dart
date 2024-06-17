import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';

final GlobalKey appBarKey = GlobalKey();

class CustomBody extends StatelessWidget {
  final Widget? appBar;
  final double? appBarHeight;
  final double? appNavHeight;
  final Widget? body;
  final bool? enableAppBarPadding;
  final bool? enableNaviBottom;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool scroller; // 根据此属性，让body为ListView还是Column
  final Color? backgroundColor;

  const CustomBody({
    super.key,
    this.appBar,
    this.body,
    this.enableAppBarPadding = true,
    this.enableNaviBottom = false,
    this.padding,
    this.margin,
    this.scroller = true,
    this.backgroundColor,
    this.appBarHeight = 0,
    this.appNavHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ));
    } else if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.dark,
      ));
    }

    final navHeight = context.mediaQueryPadding.bottom;
    double bottomPadding = 0.0;
    if (enableNaviBottom! && Platform.isAndroid) {
      bottomPadding = appNavHeight! + navHeight;
    } else if (enableNaviBottom! && Platform.isAndroid) {
      bottomPadding = navHeight;
    } else if (Platform.isIOS) {
      bottomPadding = 0.0;
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: enableAppBarPadding! ? appBarHeight! : 0,
              bottom: bottomPadding,
            ),
            color: backgroundColor ?? MyColors.background.color,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: Container(
                width: context.width,
                height: context.height,
                padding: padding,
                margin: margin,
                // child: SingleChildScrollView(
                //   physics:
                //       scroller ? const AlwaysScrollableScrollPhysics() : null,
                //   child: body,
                // ),
                child: scroller
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: body)
                    : body,
              ),
            ),
          ),
          if (appBar != null) appBar!,
        ],
      ),
    );
  }
}
