import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../../utils/date_util.dart';
import '../container/custom_container.dart';

// 定义回调函数接口
typedef EnterCallback = void Function(DateTime selectTime);

class CustomDatePicekr extends StatelessWidget {
  final String title; // 标题
  final int startYear; // 起始年
  final int endYear; // 截止年
  final bool selectNowDate; // 是否选中当前日期
  final DateTime? defaultSelectDateTime; // 选中的日期
  final VoidCallback? cancel; // 取消回调函数
  final EnterCallback? enter; // 确认回调函数

  const CustomDatePicekr(
      {super.key,
      required this.title,
      required this.startYear,
      required this.endYear,
      this.selectNowDate = false,
      this.defaultSelectDateTime,
      this.cancel,
      this.enter});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DatePickerController(
          startYear: startYear,
          endYear: endYear,
          selectNowDate: selectNowDate,
          defaultSelectDateTime: defaultSelectDateTime),
      builder: (controller) {
        return Container(
          color: Colors.white,
          width: context.width,
          height: 248,
          margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),

          /// iPhone 存在导航条
          child: Column(
            children: [
              // 弹窗标题
              SizedBox(
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
              // 滚动时间选择
              Container(
                height: 92,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                //color: Colors.amber,
                child: Row(
                  children: [
                    // 年份滚动Item
                    Expanded(
                      child: CupertinoPicker(
                        magnification: 1.1,
                        //squeeze: 1.36,
                        squeeze: 0.9,
                        //diameterRatio: 0.2,
                        useMagnifier: true,
                        itemExtent: 26,
                        onSelectedItemChanged: (int selectedItem) {
                          controller.scrollYear(selectedItem);
                        },
                        scrollController: controller.yearScrollerController,
                        selectionOverlay: Container(
                          height: 26,
                          color: Colors.transparent,
                        ),
                        children: List<Widget>.generate(
                            controller.showYearList.length, (int index) {
                          return Center(
                            child: Text(
                              controller.showYearList[index].toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: controller.selectedYear ==
                                        controller.showYearList[index]
                                    ? MyColors.textMain.color
                                    : MyColors.textSecond.color,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // 月份 滚动Item
                    Expanded(
                      child: CupertinoPicker(
                        magnification: 1.1,
                        squeeze: 0.9,
                        useMagnifier: true,
                        itemExtent: 26,
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          controller.scrollMonth(selectedItem);
                        },
                        scrollController: controller.monthScrollerController,
                        selectionOverlay: Container(
                          height: 26,
                          color: Colors.transparent,
                        ),
                        children: List<Widget>.generate(
                            controller.showMonthList.length, (int index) {
                          return Center(
                            child: Text(
                              controller.showMonthList[index].toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: controller.selectedMonth ==
                                        controller.showMonthList[index]
                                    ? MyColors.textMain.color
                                    : MyColors.textSecond.color,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // 日 滚动Item
                    Expanded(
                      child: CupertinoPicker(
                        magnification: 1.1,
                        squeeze: 0.9,
                        useMagnifier: true,
                        itemExtent: 26,
                        onSelectedItemChanged: (int selectedItem) {
                          controller.scrollDay(selectedItem);
                        },
                        scrollController: controller.dayScrollerController,
                        selectionOverlay: Container(
                          height: 26,
                          color: Colors.transparent,
                        ),
                        children: List<Widget>.generate(
                          controller.showDaysList.length,
                          (int index) {
                            return Center(
                              child: Text(
                                controller.showDaysList[index].toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: controller.selectDay ==
                                          controller.showDaysList[index]
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
              Expanded(
                child: Row(
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
                            debugPrint("点击 取消 按钮...");

                            if (null != cancel) {
                              cancel!;
                            }

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
                              "确定",
                              style: TextStyle(
                                color: MyColors.textWhite.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            debugPrint("点击 确定 按钮...");
                            if (null != enter) {
                              enter!(DateTime(
                                  controller.selectedYear,
                                  controller.selectedMonth,
                                  controller.selectDay));
                            }

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

class DatePickerController extends GetxController {
  final int startYear; // 起始年
  final int endYear; // 截止年
  final bool selectNowDate; // 是否选中当前日期
  final DateTime? defaultSelectDateTime; // 选中的日期

  late int selectedYear; // 当前选择的年
  late int selectedMonth; // 当前选择的月
  late int selectDay; // 当前选择的日
  late List<int> showYearList; // 显示的年
  late List<int> showMonthList; // 显示的月
  late List<int> showDaysList; // 显示的天

  final yearScrollerController = FixedExtentScrollController();
  final monthScrollerController = FixedExtentScrollController();
  final dayScrollerController = FixedExtentScrollController();

  bool firstShow = true;

  DatePickerController({
    required this.startYear,
    required this.endYear,
    this.selectNowDate = false,
    this.defaultSelectDateTime,
  }) {
    // 初始化时间
    if (selectNowDate && null == defaultSelectDateTime) {
      // 当前时间
      final nowDate = DateTime.now();
      selectedYear = int.parse(formatDate(nowDate, [yyyy]));
      selectedMonth = int.parse(formatDate(nowDate, [mm]));
      selectDay = int.parse(formatDate(nowDate, [dd]));
    } else if (null != defaultSelectDateTime) {
      // 设定时间
      selectedYear = int.parse(formatDate(defaultSelectDateTime!, [yyyy]));
      selectedMonth = int.parse(formatDate(defaultSelectDateTime!, [mm]));
      selectDay = int.parse(formatDate(defaultSelectDateTime!, [dd]));
    } else {
      // 默认时间
      selectedYear = startYear;
      selectedMonth = 1;
      selectDay = 1;
    }

    debugPrint(
        "selectNowDate > > > $selectNowDate, year:$selectedYear, m:$selectedMonth, day:$selectDay");

    showYearList =
        DateUtil.getBetweenYear(startYear: selectedYear, endYear: endYear);
    showMonthList = DateUtil.getAllMonthList();
    showDaysList = DateUtil.getYMdays(year: selectedYear, month: selectedMonth);
  }

  /// 滚动年
  void scrollYear(int selectedItem) {
    selectedYear = showYearList[selectedItem];
    // 月份滚动到1月
    monthScrollerController.animateToItem(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) {
      HapticFeedback.selectionClick();
    }
    update();
  }

  /// 滚动月
  void scrollMonth(int selectedItem) {
    selectedMonth = showMonthList[selectedItem];
    // 计算选中年 -> 月 -> 天
    showDaysList = DateUtil.getYMdays(year: selectedYear, month: selectedMonth);
    dayScrollerController.animateToItem(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) {
      HapticFeedback.selectionClick();
    }
    update();
  }

  /// 滚动日
  void scrollDay(int selectedItem) {
    selectDay = showDaysList[selectedItem];
    // 设置了默认选中项则不触发振动效果
    if (!firstShow) {
      HapticFeedback.selectionClick();
    }
    update();
  }

  void _initSelect() {
    // 滚动到当前日期
    if (selectNowDate) {
      yearScrollerController.jumpToItem(showYearList.indexOf(selectedYear));
      monthScrollerController.jumpToItem(showMonthList.indexOf(selectedMonth));
      dayScrollerController.jumpToItem(showDaysList.indexOf(selectDay));
    }
    firstShow = false;
  }

  @override
  void onReady() {
    super.onReady();
    _initSelect();
  }
}
