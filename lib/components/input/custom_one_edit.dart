import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';

class CustomOneEdit extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? editController;
  final bool obscureText; // 文本是否可见
  final TextInputType? keyboardType; // 输入文本类型
  final bool? enableShowBorder;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onChanged;
  final Function()? onTap;
  final bool moveTextPositionInLast; // 是否移动游标到最后

  const CustomOneEdit({
    super.key,
    this.focusNode,
    this.editController,
    this.keyboardType,
    this.enableShowBorder = false,
    this.obscureText = false,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.moveTextPositionInLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomOneEditController>(
      init: CustomOneEditController(
          focusNode: focusNode,
          editController: editController,
          keyboardType: keyboardType),
      global: false,
      builder: (controller) {
        return Container(
          //padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,

          // TextFiled 的默认高为48（fontSize：16）
          // 如果父布局比TextFiled高，需要设置padding值才能让TextFiled居中
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: enableShowBorder! && controller.showBorder
                ? Border.all(color: MyColors.coloBlue.color, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: TextField(
            //maxLengthEnforcement: MaxLengthEnforcement.none,
            showCursor: false,
            readOnly: null != onTap ? true : false,
            obscureText: controller.obscureText, // 将文本内容隐藏
            focusNode: controller.focusNode,
            controller: controller.editController,
            keyboardType: controller.keyboardType,
            inputFormatters: inputFormatters,
            textAlign: TextAlign.center,
            cursorRadius: const Radius.circular(0),
            cursorColor: MyColors.coloBlue.color,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.textMain.color,
            ),
            onChanged: (value) {
              // 如果有新输入的字符，则保留最新的字符
              if (value.isNotEmpty) {
                controller.editController!.value = TextEditingValue(
                  text: value.substring(value.length - 1),
                  selection: TextSelection.fromPosition(
                    const TextPosition(offset: 1),
                  ),
                );
              } else {
                controller.editController!.text = '';
              }
              onChanged?.call(value);
            },
            onEditingComplete: () {
              controller.focusNode?.unfocus();
            },
            onTap: () {
              controller.focusNode!.requestFocus();
              onTap?.call();

              // 将光标移动到文本的最后
              if (moveTextPositionInLast) {
                final text = controller.editController!.text;
                controller.editController!.selection =
                    TextSelection.fromPosition(
                  TextPosition(offset: text.length),
                );
              }
            },
            onTapOutside: (event) {
              controller.focusNode?.unfocus();
            },
            decoration: const InputDecoration(
              isCollapsed: true,
              isDense: true,
              counterText: '',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.black45,
              ),
              //contentPadding: const EdgeInsets.symmetric(vertical: 10),
              // 设置左边显示密码Icon
            ),
          ),
        );
      },
    );
  }
}

class CustomOneEditController extends GetxController {
  late FocusNode? focusNode;
  late TextEditingController? editController;
  late TextInputType? keyboardType; // 输入文本类型

  CustomOneEditController({
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
