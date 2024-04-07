import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vo/school_card_item_vo.dart';
import '../time_table/model/course_model.dart';
import '../time_table/course_table/timetable_vm.dart';

class SchoolPageViewModel extends GetxController {
  // 依赖
  final timeTableVM = Get.find<TimeTableViewModel>();
  // 界面
  var courseCardData = SchoolCardData.empty().obs; // 今日课程Card Model

  // event: 进入主界面 -> 更新Card中数据
  void initCourseCardData(CourseModel courseModel) {
    if (courseModel.courseAllPages.isEmpty) return;
    final schoolCardDateTemp = SchoolCardData.empty();
    DateTime now = DateTime.now();
    int nextCourseCount = 0;
    debugPrint(
        '课表周数: ${courseModel.courseAllPages.length}  当前时间周: ${timeTableVM.nowWeek}');
    // 当前时间在课表周外
    if (timeTableVM.nowWeek > courseModel.courseAllPages.length) return;
    // 根据当前日期计算出日课程，再更具课程时间计算出还剩多少节课
    final courseData = courseModel.courseAllPages[timeTableVM.nowWeek]
        .courseData[DateTime.now().weekday - 1];

    for (var i = 0; i < courseData.length; i++) {
      if (courseData[i] != null) {
        final startTime = courseModel.courseTime[i * 2].start;
        final endTime = courseModel.courseTime[i * 2 + 1].end;
        List<String> partsEnd = endTime.split(":");
        int endHour = int.parse(partsEnd[0]);
        int endMinute = int.parse(partsEnd[1]);
        DateTime endDateTime =
            DateTime(now.year, now.month, now.day, endHour, endMinute);

        // 比较时间
        //debugPrint("开始时间: $startDateTime 结束时间: $endDateTime");

        if (endDateTime.compareTo(now) >= 0) {
          nextCourseCount = nextCourseCount + 1;
          debugPrint(
              "课程名: ${courseData[i]?.name.toString()} 课程开始时间: $startTime 结束时间: $endTime");

          // 只保存第一节的时间信息
          if (nextCourseCount == 1) {
            schoolCardDateTemp.data = courseData[i];
            schoolCardDateTemp.startTime = startTime;
            schoolCardDateTemp.endTime = endTime;
          }
        }
      }
    }

    // 更新有几节未上课程
    if (nextCourseCount > 0) {
      schoolCardDateTemp.info = "$nextCourseCount节课程";
    } else {
      schoolCardDateTemp.info = "暂无课程";
    }
    schoolCardDateTemp.updateTime = formatDate(now, [hh, ':', nn]);

    courseCardData(schoolCardDateTemp);
  }

  @override
  void onReady() {
    super.onReady();
    initCourseCardData(timeTableVM.courseModel.value);
  }
}
