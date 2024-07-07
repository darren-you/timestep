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
  final todoPageController =
      PageController(initialPage: DateTime.now().day - 1);

  /// 初始化日期数据
  void _initDateTime() {
    yearMonthText = DateFormat('y-M').format(currentDayDateTime.value).obs;
    daysInMonthList = Rx(DateUtil.getDaysInMonth(currentMonthDateTime.value));
  }

  /// 更新 年-月、月份List
  void refreshDateInfo() {
    yearMonthText.value = DateFormat('y-M').format(currentDayDateTime.value);
    daysInMonthList.value = DateUtil.getDaysInMonth(currentMonthDateTime.value);
    // 需要在绘制完成后滚动
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollerByDayChanged(useAnimation: true);
      _pageScrollerByDay();
    });
  }

  /// 展开、收起 日期列表
  void tapDateTextInfo() {
    // 展开前先滚动选中日期位置
    if (!isExpanded.value) {
      _scrollerByDayChanged(useAnimation: false);
    }
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

  /// 月份加、减操作
  ///
  /// 若为同年、同月则，则设定选中日期为今日
  /// 否则则设置为当月1日
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

  /// 自动滚动日历列表
  ///
  /// 未选中：本月则滚动到今天、非本月则滚动到1号
  /// 选中：滚动到具体日期位置（居中显示）
  void _scrollerByDayChanged({required bool useAnimation}) {
    final offest = _getOffsetByCurrentDay();
    logger.d('currentDay: ${currentMonthDateTime.value.day} offest: $offest');
    if (useAnimation) {
      dayInMonthScrollController.animateTo(offest,
          duration: const Duration(milliseconds: 1800),
          curve: Curves.fastLinearToSlowEaseIn);
    } else {
      dayInMonthScrollController.jumpTo(offest);
    }
  }

  /// 计算滚动offset
  ///
  /// 让选中day显示在中间
  double _getOffsetByCurrentDay() {
    // 滚动长度
    var offset = 0.0;
    final screenWidth = MyScreenUtil.getInstance().screenWidth;
    final halfScreenWidth = screenWidth / 2;
    final halfScreenItem = (halfScreenWidth / (42.h + 8.w)).ceil();
    // 选中day
    final selectedDay = currentDayDateTime.value.day;
    // 选中月有多少天
    final daysInMonth =
        DateUtil.getDaysInMonthByDateTime(currentMonthDateTime.value);
    if (selectedDay > halfScreenItem &&
        selectedDay <= (daysInMonth - halfScreenItem)) {
      offset = selectedDay * (42.h + 8.w) - (42.h / 2) - halfScreenWidth;
    } else if (selectedDay <= halfScreenItem) {
      offset = 0;
    } else {
      offset = daysInMonth * (42.h + 8.w) + 8.w - screenWidth;
    }

    return offset;
  }

  /// 点击某一天
  void tapOneDay(DateTime dateTime) {
    currentDayDateTime.value = dateTime;
    _scrollerByDayChanged(useAnimation: true);
    _pageScrollerByDay();
  }

  /// 滑动Todo PageView
  ///
  /// 需要同步滑动dayInMonth
  void todoPageChanged(int pageIndex) {
    currentDayDateTime.value = DateTime(currentDayDateTime.value.year,
        currentDayDateTime.value.month, pageIndex);
    _scrollerByDayChanged(useAnimation: true);
    logger.d('当前 index: $pageIndex');
  }

  /// PageView自动滚动
  void _pageScrollerByDay() {
    todoPageController.jumpToPage(currentDayDateTime.value.day - 1);
  }

  @override
  void onInit() {
    _initDateTime();
    super.onInit();
  }
}
