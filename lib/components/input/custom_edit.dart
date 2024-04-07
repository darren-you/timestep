import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../../utils/assert_util.dart';
import '../container/custom_icon_button.dart';

class CustomEdit extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? editController;
  final bool obscureText; // 文本是否可见
  final bool showSuffixIcon; // 右侧图标是否显示
  final TextInputType? keyboardType; // 输入文本类型
  final String? hintText;
  final bool? enableShowBorder;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onChanged;
  final Function()? onTap;

  const CustomEdit({
    Key? key,
    this.focusNode,
    this.editController,
    this.keyboardType,
    this.hintText,
    this.enableShowBorder = false,
    this.obscureText = false,
    this.showSuffixIcon = true,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomEditController>(
      init: CustomEditController(
          focusNode: focusNode,
          editController: editController,
          keyboardType: keyboardType),
      global: false,
      builder: (controller) {
        return Container(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: enableShowBorder! && controller.showBorder
                ? Border.all(color: MyColors.coloBlue.color, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: TextField(
            //maxLengthEnforcement: MaxLengthEnforcement.none,
            readOnly: null != onTap ? true : false,
            maxLength: maxLength,
            obscureText: controller.obscureText, // 将文本内容隐藏
            focusNode: controller.focusNode,
            controller: controller.editController,
            keyboardType: controller.keyboardType,
            inputFormatters: inputFormatters,
            textAlign: TextAlign.center,
            cursorRadius: const Radius.circular(0),
            cursorColor: MyColors.coloBlue.color,
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
              counterText: '',
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.black45,
              ),
              // 设置左边显示密码Icon
              prefixIconConstraints: const BoxConstraints(
                maxWidth: 40,
                maxHeight: 48,
              ),
              prefixIcon: Container(
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  //color: Colors.blue,
                ),
                // fix 此处图标切换有抖动，大小也需要调整
                child: (controller.focusNode!.hasFocus &&
                        keyboardType == TextInputType.visiblePassword)
                    ? CustomIconButton(
                        controller.showPassword
                            ? AssertUtil.visibleSvg
                            : AssertUtil.invisibleSvg,
                        iconSize: 20,
                        onTap: () {
                          controller.toggleShowPass();
                        },
                      )
                    : Container(color: Colors.transparent),
              ),

              // 设置右边显示删除输入Icon
              suffixIconConstraints: const BoxConstraints(
                maxWidth: 40,
                maxHeight: 48,
              ),
              suffixIcon: Container(
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  //color: Colors.blue,
                ),
                child: (controller.focusNode!.hasFocus &&
                        controller.editController!.text.isNotEmpty &&
                        showSuffixIcon)
                    ? CustomIconButton(
                        AssertUtil.closeSvg,
                        //margin: const EdgeInsets.symmetric(horizontal: 12),
                        iconSize: 12,
                        onTap: () {
                          controller.clearText();
                          // 调用回调函数
                          if (null != onChanged) {
                            onChanged!('');
                          }
                        },
                      )
                    : Container(color: Colors.transparent),
              ),
            ),
          ),
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
