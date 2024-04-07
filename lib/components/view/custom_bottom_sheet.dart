import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<T?> showMyBottomSheet<T>(
  BuildContext context, {
  required Widget showChild,
  bool scrollControlled = false,
  Color? backgroundColor = Colors.white,
  EdgeInsets? bodyPadding = const EdgeInsets.all(0),
  BorderRadius? radius = const BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
}) async {
  // 在BottomSheet拉起时，需要根据背景使底部导航栏沉静
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
    ));
  }

  T? result = await showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    elevation: 0,
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: radius!),
    barrierColor: Colors.black.withOpacity(0.25),
    // A处
    constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewPadding.top,
        maxWidth: context.width),
    isScrollControlled: scrollControlled,
    builder: (context) => showChild,
  );

  // 关闭BottomSheet时恢复背景色
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  return result;
}
