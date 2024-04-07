import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../container/custom_container.dart';

Future<T?> showBottomMsgDialog<T>(
  BuildContext context, {
  required String title,
  required String msg,
  Widget? showChild,
  bool scrollControlled = false,
  Color? backgroundColor = Colors.white,
  EdgeInsets? bodyPadding = const EdgeInsets.all(0),
  BorderRadius? radius = const BorderRadius.only(
      topLeft: Radius.circular(16), topRight: Radius.circular(16)),
  VoidCallback? cancel, // 取消回调函数
  VoidCallback? entr, // 确定回调函数
  String rightButtonText = '确定',
}) {
  // MediaQuery.of(context).viewPadding.bottom,
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    elevation: 0,
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: radius!),
    barrierColor: Colors.black.withOpacity(0.25),
    constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top) /
            3,
        maxWidth: context.width),
    isScrollControlled: scrollControlled,
    builder: (context) {
      return Column(
        children: [
          Expanded(
              child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                  child: Center(
                child: Text(msg),
              ))
            ],
          )),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.only(
                      left: 16, top: 16, right: 8, bottom: 16),
                  //color: Colors.white,
                  child: CustomContainer(
                    duration: const Duration(milliseconds: 200),
                    borderRadius: BorderRadius.circular(30),
                    color: MyColors.background.color,
                    child: Center(
                      child: Text(
                        "取消",
                        style: TextStyle(
                          color: MyColors.textMain.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      cancel?.call();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.only(
                      left: 8, top: 16, right: 16, bottom: 16),
                  //color: Colors.white,
                  child: CustomContainer(
                    duration: const Duration(milliseconds: 200),
                    borderRadius: BorderRadius.circular(30),
                    color: MyColors.iconBlue.color,
                    child: Center(
                      child: Text(
                        rightButtonText,
                        style: TextStyle(
                          color: MyColors.textWhite.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      entr?.call();
                    },
                  ),
                ),
              ),
            ],
          ),
          Platform.isIOS
              ? SizedBox(height: context.mediaQueryPadding.bottom)
              : const SizedBox(),
        ],
      );
    },
  );
}
