import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../enumm/course_enum.dart';
import '../course_table/timetable_vm.dart';
import '../repository/course_data_service.dart';

class TimeTableSeetingPageViewModel extends GetxController {
  // 依赖
  final _courseRepo = Get.find<CourseDataService>();
  final _timeTableViewModel = Get.find<TimeTableViewModel>();

  // 状态
  var oneWeekDayEnum = OneWeekDayEnum.week5.obs; // 是否显示周末课程
  var changeCourseEnum = ChangeCourseEnum.off.obs; // 是否开启课程快捷切换

  // 事件
  // event: 点击显示周末课程switcher -> 更新缓存变量
  void showWeekend(bool value) {
    if (value) {
      oneWeekDayEnum.value = OneWeekDayEnum.week7;
    } else {
      oneWeekDayEnum.value = OneWeekDayEnum.week5;
    }

    debugPrint("更新 <显示周末课程> 缓存数据为: ${oneWeekDayEnum.value.day}");
    // 立即更新，多次重复点击可能会增加开销
    _timeTableViewModel.weekDay.value = oneWeekDayEnum.value;
  }

  // event: 点击开启快捷切换课表
  void enableChangeCourse(bool vale) {
    if (vale) {
      changeCourseEnum.value = ChangeCourseEnum.on;
    } else {
      changeCourseEnum.value = ChangeCourseEnum.off;
    }

    _timeTableViewModel.changeCourseSate.value = changeCourseEnum.value;
  }

  // event: 进入页面 -> 初始化本地设置数据
  void _initLocalSetting() {
    oneWeekDayEnum.value = _courseRepo.getShowWeekend();
    changeCourseEnum.value = _courseRepo.getChangeCourse();
  }

  // event: 关闭页面 -> 判断显示周末课程设置是否更，决定是否写入本地 / 更新主页 timeTableViewModel.weekDay
  void _saveShowWeekendSetting() {
    final oldOneWeekDayEnum = _courseRepo.getShowWeekend();
    final oldChangeCourseEnum = _courseRepo.getChangeCourse();

    if (oneWeekDayEnum.value != oldOneWeekDayEnum) {
      //更新状态
      // 页面关闭再更新，有延时不知道咋解决
      //_timeTableViewModel.weekDay.value = oneWeekDayEnum.value;
      // 写入本地
      _courseRepo.saveShowWeekend(oneWeekDayEnum.value);
    }

    if (changeCourseEnum.value != oldChangeCourseEnum) {
      _courseRepo.saveChangeCourse(changeCourseEnum.value);

      if (changeCourseEnum.value == ChangeCourseEnum.off) {
        // 如果关闭了，切换课表则，需要更新主页显示第一个课表
        _timeTableViewModel.initPageState();
        _timeTableViewModel.toNowWeekPage(animate: false);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initLocalSetting();
  }

  @override
  void onClose() {
    super.onClose();
    _saveShowWeekendSetting();
  }
}
