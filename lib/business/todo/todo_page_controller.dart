import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timestep/services/app_init_service.dart';
import 'package:timestep/utils/date_util.dart';
import 'package:timestep/utils/my_screen_util.dart';

class TodoPageController extends GetxController {
  var currentMonthDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, 1).obs; // 选中月
  var currentDayDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs; // 选中日期
  late Rx<String> yearMonthText;
  late Rx<List<DateTime>> daysInMonthList;
  var isExpanded = false.obs; // 日期收否展开

  // UI
  final dayInMonthScrollController = ScrollController();

  /// 初始化日期数据
  void _initDateTime() {
    yearMonthText = DateFormat('y-M').format(currentDayDateTime.value).obs;
    daysInMonthList = Rx(DateUtil.getDaysInMonth(currentMonthDateTime.value));
  }

  /// 更新 年-月、月份List
  void refreshDateInfo() {
    yearMonthText.value = DateFormat('y-M').format(currentDayDateTime.value);
    daysInMonthList.value = DateUtil.getDaysInMonth(currentMonthDateTime.value);
    // 滚动
    _scrollerByMonthChanged();
  }

  /// 单击日期信息
  void tapDateTextInfo() {
    isExpanded.value = !isExpanded.value;
  }

  /// 双击日期信息
  ///
  /// 回到本月
  void doubleTapDateTextInfo() {
    currentMonthDateTime.value =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    currentDayDateTime.value =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    refreshDateInfo();
  }

  /// 月份减
  ///
  /// 若为同年、同月则，则设定为今日
  void monthLeftOrRight({required bool isLeft}) {
    var dateTime = isLeft
        ? DateUtil.getPreviousMonth(currentMonthDateTime.value)
        : DateUtil.getAfterMonth(currentMonthDateTime.value);

    if (DateUtil.isSameYearAndMonth(dateTime)) {
      dateTime = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    }

    currentMonthDateTime.value = dateTime;
    currentDayDateTime.value = dateTime;
    refreshDateInfo();
  }

  /// 月份滚动到第一天
  ///
  /// 本月则滚动到今天、非本月则滚动到1号
  void _scrollerByMonthChanged() {
    var offest = 0.0;
    if (DateUtil.isSameYearAndMonth(currentMonthDateTime.value)) {
      offest = _getOffsetByDay();
    }

    logger.d('currentDay: ${currentMonthDateTime.value.day} offest: $offest');

    dayInMonthScrollController.animateTo(offest,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  /// 计算滚动offset
  double _getOffsetByDay() {
    var offset = currentDayDateTime.value.day * (42.h + 8);
    // 计算一屏能容纳多少item
    final screenShowCount =
        MyScreenUtil.getInstance().screenWidth ~/ (42.h + 8);
    // 选中月有多少天
    final daysInMonth =
        DateUtil.getDaysInMonthByDateTime(currentMonthDateTime.value);
    // 判断是否在末尾一屏内
    if (currentDayDateTime.value.day > (daysInMonth - screenShowCount)) {
      logger.d('${currentDayDateTime.value.day} 在末尾一屏内');
      final leftOffset = MyScreenUtil.getInstance().screenWidth -
          (42.h + 8) * screenShowCount -
          8;
      offset = (daysInMonth - screenShowCount) * (42.h + 8) - leftOffset;
    }

    return offset;
  }

  /// 点击某一天
  void tapOneDay(DateTime dateTime) {
    currentDayDateTime.value = dateTime;
  }

  @override
  void onInit() {
    _initDateTime();
    super.onInit();
  }

  @override
  void onReady() {
    refreshDateInfo();
    super.onReady();
  }
}
