import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../container/custom_container.dart';

// 定义确定回调函数
typedef EnterCallback = void Function(List<int> allSelectIndex);

class CustomBottomSheetPicker extends StatelessWidget {
  final String title;
  final List<String>? firstList; // 滚动列表 1
  final int firstListDefaultSelect;
  final List<String>? secondList; // 滚动列表 2
  final int secondListDefaultSelect;
  final List<String>? thirdList; // 滚动列表 3
  final int thirdListDefaultSelect;
  final VoidCallback? cancel; // 取消回调函数
  final EnterCallback? enter; // 确认回调函数

  const CustomBottomSheetPicker(
      {super.key,
      this.title = '',
      this.firstList,
      this.firstListDefaultSelect = 0,
      this.secondList,
      this.secondListDefaultSelect = 0,
      this.thirdList,
      this.thirdListDefaultSelect = 0,
      this.cancel,
      this.enter});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CustomBottomSheetPickerController(
        firstListDefaultSelect: firstListDefaultSelect,
        secondListDefaultSelect: secondListDefaultSelect,
        thirdListDefaultSelect: thirdListDefaultSelect,
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
                    firstList != null
                        ? Expanded(
                            child: CupertinoPicker(
                              magnification: 1.1,
                              //squeeze: 1.36,
                              squeeze: 0.9,
                              //diameterRatio: 0.2,
                              useMagnifier: true,
                              itemExtent: 26,
                              scrollController:
                                  controller.firstScrollerController,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                debugPrint("第一项: > > > $selectedItem");
                                controller.scrollerFirstList(selectedItem);
                              },
                              selectionOverlay: Container(
                                height: 26,
                                color: Colors.transparent,
                              ),
                              children: List<Widget>.generate(
                                firstList!.length,
                                (int index) {
                                  return Center(
                                    child: Text(
                                      firstList![index].toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: controller.firstSelected == index
                                            ? MyColors.textMain.color
                                            : MyColors.textSecond.color,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),

                    secondList != null
                        ? Expanded(
                            child: CupertinoPicker(
                              magnification: 1.1,
                              //squeeze: 1.36,
                              squeeze: 0.9,
                              //diameterRatio: 0.2,
                              useMagnifier: true,
                              itemExtent: 26,
                              scrollController:
                                  controller.secondScrollerController,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                debugPrint("item2: > > > $selectedItem");
                                controller.scrollerSecondList(selectedItem);
                              },
                              selectionOverlay: Container(
                                height: 26,
                                color: Colors.transparent,
                              ),
                              children: List<Widget>.generate(
                                secondList!.length,
                                (int index) {
                                  return Center(
                                    child: Text(
                                      secondList![index].toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            controller.secondSelected == index
                                                ? MyColors.textMain.color
                                                : MyColors.textSecond.color,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),

                    thirdList != null
                        ? Expanded(
                            child: CupertinoPicker(
                              magnification: 1.1,
                              //squeeze: 1.36,
                              squeeze: 0.9,
                              //diameterRatio: 0.2,
                              useMagnifier: true,
                              itemExtent: 26,
                              scrollController:
                                  controller.thirdScrollerController,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                debugPrint("item3: > > > $selectedItem");
                                controller.scrollerThirdList(selectedItem);
                              },
                              selectionOverlay: Container(
                                height: 26,
                                color: Colors.transparent,
                              ),
                              children: List<Widget>.generate(
                                thirdList!.length,
                                (int index) {
                                  return Center(
                                    child: Text(
                                      thirdList![index].toString(),
                                      style: TextStyle(
                                        color: controller.thirdSelected == index
                                            ? MyColors.textMain.color
                                            : MyColors.textSecond.color,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),
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
                              controller.thirdSelected
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

class CustomBottomSheetPickerController extends GetxController {
  int firstListDefaultSelect;
  int secondListDefaultSelect;
  int thirdListDefaultSelect;

  bool firstShow = true;

  CustomBottomSheetPickerController({
    this.firstListDefaultSelect = 0,
    this.secondListDefaultSelect = 0,
    this.thirdListDefaultSelect = 0,
  });

  late final firstScrollerController = FixedExtentScrollController();
  late final secondScrollerController = FixedExtentScrollController();
  late final thirdScrollerController = FixedExtentScrollController();

  // 定义可观察数据
  var firstSelected = 0;
  var secondSelected = 0;
  var thirdSelected = 0;

  /// 初始化列表选中项
  void _initSelect() {
    firstScrollerController.jumpToItem(firstListDefaultSelect);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("第一列更新后执行");
      secondScrollerController.jumpToItem(secondListDefaultSelect);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("第二列更新后执行");
      thirdScrollerController.jumpToItem(thirdListDefaultSelect);
      firstShow = false;
    });
  }

  // 滚动列表1
  void scrollerFirstList(int selectedItem) {
    firstSelected = selectedItem;
    secondScrollerController.animateToItem(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) HapticFeedback.selectionClick();
    update();
  }

  void scrollerSecondList(int selectedItem) {
    secondSelected = selectedItem;
    thirdScrollerController.animateToItem(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) HapticFeedback.selectionClick();
    update();
  }

  void scrollerThirdList(int selectedItem) {
    thirdSelected = selectedItem;
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) HapticFeedback.selectionClick();
    update();
  }

  @override
  void onReady() {
    super.onReady();
    _initSelect();
  }
}
