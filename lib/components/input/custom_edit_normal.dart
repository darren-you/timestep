import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../../utils/assert_util.dart';
import '../../utils/color_util.dart';
import '../container/custom_icon_button.dart';

class CustomEditNormal extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? cursorColor;
  final Widget? leftIcon;
  final TextAlign textAlign;
  final BorderRadiusGeometry? borderRadius;
  final FocusNode? focusNode;
  final TextEditingController? editController;
  final bool showSuffixIcon;
  final bool obscureText; // 文本是否可见
  final TextInputType? keyboardType; // 输入文本类型
  final String? hintText;
  final TextStyle? hintStyle;
  final bool? enableShowBorder;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onChanged;
  final Function()? onTap;

  const CustomEditNormal({
    super.key,
    this.width,
    this.height,
    this.backgroundColor = Colors.white,
    this.cursorColor,
    this.leftIcon,
    this.textAlign = TextAlign.left,
    this.borderRadius,
    this.focusNode,
    this.editController,
    this.keyboardType,
    this.hintText,
    this.hintStyle,
    this.enableShowBorder = false,
    this.showSuffixIcon = true,
    this.obscureText = false,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomEditController>(
      init: CustomEditController(
          focusNode: focusNode,
          editController: editController,
          keyboardType: keyboardType),
      global: false,
      builder: (controller) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              clipBehavior: Clip.hardEdge,
              width: width ?? constraints.maxWidth,
              height: height ?? 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                border: enableShowBorder! && controller.showBorder
                    ? Border.all(color: MyColors.coloBlue.color, width: 2)
                    : Border.all(color: Colors.transparent, width: 2),
              ),
              child: TextField(
                //maxLengthEnforcement: MaxLengthEnforcement.none,
                readOnly: null != onTap ? true : false,
                maxLength: maxLength,
                textAlignVertical: TextAlignVertical.center,
                obscureText: controller.obscureText, // 将文本内容隐藏
                focusNode: controller.focusNode,
                controller: controller.editController,
                keyboardType: controller.keyboardType,
                inputFormatters: inputFormatters,
                textAlign: textAlign,
                cursorRadius: const Radius.circular(0),
                cursorColor: cursorColor ?? MyColors.coloBlue.color,
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.textMain.color,
                ),
                onChanged: (value) {
                  if (null != onChanged) {
                    onChanged!(value);
                  }
                },
                onEditingComplete: () {
                  controller.focusNode!.unfocus();
                },
                onTap: onTap,
                onTapOutside: (event) {
                  debugPrint("点击外部区域 $focusNode");
                  controller.focusNode!.unfocus();
                },
                decoration: InputDecoration(
                  isCollapsed: true,
                  isDense: true,
                  counterText: '',
                  border: InputBorder.none,
                  hintText: hintText,

                  hintStyle: hintStyle,
                  // 设置左边显示密码Icon
                  prefixIconConstraints: const BoxConstraints(
                    maxWidth: 48,
                    maxHeight: 48,
                  ),
                  prefixIcon: leftIcon != null
                      ? Container(
                          alignment: Alignment.center,
                          width: 48,
                          //color: Colors.amber,
                          // fix 此处图标切换有抖动，大小也需要调整
                          child: leftIcon,
                        )
                      : const SizedBox(
                          width: 16,
                        ),

                  // 设置右边显示删除输入Icon
                  suffixIconConstraints: const BoxConstraints(
                    maxWidth: 48,
                    maxHeight: 48,
                  ),
                  suffixIcon: showSuffixIcon
                      ? Container(
                          alignment: Alignment.center,
                          width: 48,
                          //color: Colors.amber,
                          // fix 此处图标切换有抖动，大小也需要调整
                          child: (controller.focusNode!.hasFocus &&
                                  keyboardType ==
                                      TextInputType.visiblePassword &&
                                  showSuffixIcon)
                              ? CustomIconButton(
                                  controller.showPassword
                                      ? AssertUtil.iconVisible
                                      : AssertUtil.iconInvisible,
                                  iconSize: 22,
                                  defaultColor: HexColor("#A2A2A2"),
                                  onTap: () {
                                    controller.toggleShowPass();
                                  },
                                )
                              : Container(
                                  color: Colors.transparent,
                                ),
                        )
                      : const SizedBox(width: 16),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomEditController extends GetxController {
  late FocusNode? focusNode;
  late TextEditingController? editController;
  late TextInputType? keyboardType; // 输入文本类型

  CustomEditController({
    required this.focusNode,
    required this.editController,
    required this.keyboardType,
  });

  bool showBorder = false; // 控制是否显示边框
  bool showCloseIcon = false; // 控制是否显示清除按钮
  bool showPassword = false; // 输入框左Icon控制是否明文显示密码
  bool obscureText = false; // 开启隐藏显示密码

  @override
  void onInit() {
    super.onInit();

    editController ??= TextEditingController();

    focusNode = focusNode ?? FocusNode();
    focusNode!.addListener(() {
      showBorder = focusNode!.hasFocus;
      update();
    });
    editController?.addListener(() {
      showCloseIcon = editController!.text.isNotEmpty;
      update();
    });

    if (keyboardType == TextInputType.visiblePassword &&
        showPassword == false) {
      obscureText = true;
      update();
    }
  }

  void clearText() {
    editController?.clear();
  }

  // 反转是否显明文示密码
  void toggleShowPass() {
    showPassword = !showPassword;
    obscureText = !obscureText;
    update();
  }

  @override
  void onClose() {
    editController?.dispose();
    super.onClose();
  }
}
