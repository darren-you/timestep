import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:timestep/services/app_init_service.dart';
import 'package:timestep/utils/date_util.dart';

class TodoPageController extends GetxController {
  var currentMonthDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs; // 选中月
  var currentDayDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs; // 选中日期
  late Rx<String> monthDayText;
  late Rx<List<DateTime>> daysInMonthList;
  var isExpanded = false.obs; // 日期收否展开

  // UI
  final dateTimeScrollController = ScrollController();

  /// 更新日期信息
  void refreshDateInfo() {
    monthDayText = DateUtil.getMonthDayText(currentDayDateTime.value).obs;
    daysInMonthList = Rx(DateUtil.getDaysInMonth(currentMonthDateTime.value));
  }

  /// 点击日期信息
  void tapDateTextInfo() {
    isExpanded.value = !isExpanded.value;
  }

  @override
  void onInit() {
    refreshDateInfo();

    logger.d('TodoPageController 初始化完成 > > > > > > .........');

    super.onInit();
  }
}
