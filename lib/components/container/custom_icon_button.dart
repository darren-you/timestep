import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

/*
  封装的 Icon 按下后，会使Svg Icon变灰
  使用Container封装，IconButton 会有自带的Padding和Margin值，赋值取消不了，不利于精确布局
 */
class CustomIconButton extends StatelessWidget {
  final String assetName;
  final double? backgroundWidth;
  final double? backgroundHeight;
  final VoidCallback? onTap;
  final Color defaultColor;
  final Color pressedColor;
  final double? iconSize;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? background;

  const CustomIconButton(
    this.assetName, {
    super.key,
    this.onTap,
    this.defaultColor = Colors.black,
    this.pressedColor = Colors.grey,
    this.iconSize,
    this.alignment = Alignment.center,
    this.padding,
    this.background,
    this.margin,
    this.backgroundWidth,
    this.backgroundHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyIconButtonController>(
      init: MyIconButtonController(),
      global: false,
      builder: (controller) => GestureDetector(
        onTapDown: (details) {
          controller.setPressed(true);
        },
        onTapUp: (details) {
          controller.setPressed(false);
        },
        onTapCancel: () {
          controller.setPressed(false);
        },
        onTap: onTap,
        child: Container(
          alignment: alignment,
          color: background ?? Colors.transparent,
          width: backgroundWidth, // icon 的背景宽
          height: backgroundHeight, // icon 的背景高          /
          padding: padding,
          margin: margin,
          child: SvgPicture.asset(
            assetName,
            width: iconSize ?? 16,
            height: iconSize ?? 16,
            colorFilter: ColorFilter.mode(
              controller.isPressed ? pressedColor : defaultColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class MyIconButtonController extends GetxController {
  bool _isPressed = false;

  bool get isPressed => _isPressed;

  void setPressed(bool value) {
    _isPressed = value;
    update();
  }
}
