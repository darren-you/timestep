import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'custom_one_edit.dart';

// 定义确定回调函数
typedef InputCompleteCallback = void Function(
    List<dynamic> fourInputDate, String inputDate);

class CustomFourEdit extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final InputCompleteCallback? inputCompletedCallback;
  final VoidCallback? notCompletedCallBack;

  const CustomFourEdit(
      {super.key,
      this.inputFormatters,
      this.inputCompletedCallback,
      this.notCompletedCallBack});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CustomFourEditController(
          inputCompleteCallback: inputCompletedCallback,
          notCompletedCallBack: notCompletedCallBack),
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            controller.allTextEditingController.length,
            (index) {
              return CustomOneEdit(
                enableShowBorder: true,
                editController: controller.allTextEditingController[index],
                inputFormatters: inputFormatters,
                focusNode: controller.allFocusNode[index],
                moveTextPositionInLast: true,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.allFocusNode[index].unfocus();
                    if (index <
                        controller.allTextEditingController.length - 1) {
                      for (var i = 0;
                          i <
                              controller.allTextEditingController.length -
                                  (index + 1);
                          i++) {
                        if (controller.allTextEditingController[index + i + 1]
                            .text.isEmpty) {
                          controller.allFocusNode[index + i + 1].requestFocus();
                          break;
                        }
                      }
                    }
                  }
                  controller.inputDone();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class CustomFourEditController extends GetxController {
  final InputCompleteCallback? inputCompleteCallback;
  final VoidCallback? notCompletedCallBack;

  final List<TextEditingController> allTextEditingController = [];
  final List<FocusNode> allFocusNode = [];

  CustomFourEditController(
      {this.notCompletedCallBack, this.inputCompleteCallback});

  /*
   * 输入完成回调函数
   */
  void inputDone() {
    final firstDate = allTextEditingController[0].text;
    final secondDate = allTextEditingController[1].text;
    final thirdDate = allTextEditingController[2].text;
    final fourthDate = allTextEditingController[3].text;

    // 判断是否每个输入框都有值
    if (firstDate.isNotEmpty &&
        secondDate.isNotEmpty &&
        thirdDate.isNotEmpty &&
        fourthDate.isNotEmpty) {
      for (var element in allFocusNode) {
        element.unfocus();
      }
      inputCompleteCallback?.call(
        [firstDate, secondDate, thirdDate, fourthDate],
        "$firstDate$secondDate$thirdDate$fourthDate",
      );
    } else {
      notCompletedCallBack?.call();
    }
  }

  @override
  void onInit() {
    super.onInit();

    for (var i = 0; i < 4; i++) {
      allTextEditingController.add(TextEditingController());
      allFocusNode.add(FocusNode());
    }
  }

  @override
  void onClose() {
    super.onClose();

    for (var focus in allFocusNode) {
      focus.dispose();
    }
    for (var controller in allTextEditingController) {
      controller.dispose();
    }
  }
}
