import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../container/custom_container.dart';

// 定义确定回调函数
typedef EnterCallback = void Function(List<int> allSelectIndex);

class TwoAutoScrollerPicker extends StatelessWidget {
  final String title;
  final Map<String, List<String>> dateList;
  final int firstDefaultSelect;
  final int secondDefaultSelect;
  final double? firstFontSize;
  final double? secondFontSize;
  final VoidCallback? cancel; // 取消回调函数
  final EnterCallback? enter; // 确认回调函数

  const TwoAutoScrollerPicker({
    super.key,
    this.title = '',
    required this.dateList,
    this.firstDefaultSelect = 0,
    this.secondDefaultSelect = 0,
    this.firstFontSize = 20,
    this.secondFontSize = 20,
    this.cancel,
    this.enter,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TwoAutoScrollerPickerController(
        firstListDefaultSelect: firstDefaultSelect,
        secondListDefaultSelect: secondDefaultSelect,
      ),
      builder: (controller) {
        return Container(
          width: context.width,
          height: 248,
          margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
          color: Colors.white,
          child: Column(
            children: [
              // 标题
              Container(
                color: Colors.white,
                height: 76,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // 滚动部分
              Container(
                height: 92,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                //color: Colors.amber,
                child: Row(
                  children: [
                    // item1List
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: controller.firstScrollerController,
                        magnification: 1.1,
                        //squeeze: 1.36,
                        squeeze: 0.9,
                        //diameterRatio: 0.2,
                        useMagnifier: true,
                        itemExtent: 26,
                        onSelectedItemChanged: (int selectedItem) {
                          debugPrint("第一列: > > > $selectedItem");
                          controller.scrollerFirstList(selectedItem);
                        },
                        selectionOverlay: Container(
                          height: 26,
                          color: Colors.transparent,
                        ),
                        children: List<Widget>.generate(
                          dateList.keys.toList().length,
                          (int index) {
                            return Center(
                              child: Text(
                                dateList.keys.toList()[index].toString(),
                                style: TextStyle(
                                  fontSize: firstFontSize,
                                  color: controller.firstSelected == index
                                      ? MyColors.textMain.color
                                      : MyColors.textSecond.color,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      child: CupertinoPicker(
                        scrollController: controller.secondScrollerController,
                        magnification: 1.1,
                        //squeeze: 1.36,
                        squeeze: 0.9,
                        //diameterRatio: 0.2,
                        useMagnifier: true,
                        itemExtent: 26,
                        onSelectedItemChanged: (int selectedItem) {
                          debugPrint("第二列: > > > $selectedItem");
                          controller.scrollerSecondList(selectedItem);
                        },
                        selectionOverlay: Container(
                          height: 26,
                          color: Colors.transparent,
                        ),
                        children: List<Widget>.generate(
                          dateList.values
                              .toList()[controller.firstSelected]
                              .length,
                          (int index) {
                            return Center(
                              child: Text(
                                dateList.values
                                    .toList()[controller.firstSelected][index]
                                    .toString(),
                                style: TextStyle(
                                  fontSize: secondFontSize,
                                  color: controller.secondSelected == index
                                      ? MyColors.textMain.color
                                      : MyColors.textSecond.color,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 取消 | 确定 按钮
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 16, top: 16, right: 8, bottom: 16),
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
                            debugPrint("点击 取消 按钮...");
                            cancel?.call();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, top: 16, right: 16, bottom: 16),
                        //color: Colors.white,
                        child: CustomContainer(
                          duration: const Duration(milliseconds: 200),
                          borderRadius: BorderRadius.circular(30),
                          color: MyColors.iconBlue.color,
                          child: Center(
                            child: Text(
                              "确定",
                              style: TextStyle(
                                color: MyColors.textWhite.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            debugPrint("点击 确定 按钮...");
                            enter?.call([
                              controller.firstSelected,
                              controller.secondSelected,
                            ]);

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TwoAutoScrollerPickerController extends GetxController {
  int firstListDefaultSelect = 0;
  int secondListDefaultSelect = 0;
  bool firstShow = true;

  var firstScrollerController = FixedExtentScrollController();
  var secondScrollerController = FixedExtentScrollController();

  TwoAutoScrollerPickerController({
    this.firstListDefaultSelect = 0,
    this.secondListDefaultSelect = 0,
  });

  // 定义可观察数据
  var firstSelected = 0;
  var secondSelected = 0;

  /// 滚动列表1
  void scrollerFirstList(int selectedItem) {
    firstSelected = selectedItem;
    // 滚动第一个列表，让第二个列表选中第一项
    secondScrollerController.animateToItem(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) HapticFeedback.selectionClick();
    update();
  }

  /// 滚动列表2
  void scrollerSecondList(int selectedItem) {
    secondSelected = selectedItem;
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) HapticFeedback.selectionClick();
    update();
  }

  void _initSelect() {
    debugPrint(
        '初始化选中项 > > > :  $firstListDefaultSelect : $secondListDefaultSelect');
    firstScrollerController.jumpToItem(firstListDefaultSelect);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("这里的代码会在UI更新后执行");
      secondScrollerController.jumpToItem(secondListDefaultSelect);
      firstShow = false;
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initSelect();
  }
}
